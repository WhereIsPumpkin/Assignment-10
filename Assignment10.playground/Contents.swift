struct Planet {
    var name: String
    var samples: [String]
    var oxygenLevel: Int
}

class StationModule {
    let moduleName: String
    var drone: Drone?
    
    init(moduleName: String) {
        self.moduleName = moduleName
    }
    
    func assignDrone(drone: Drone) {
        self.drone = drone
    }
}

class ControlCenter: StationModule {
    fileprivate var isLockedDown: Bool = false
    private var securityCode: String
    
    init(moduleName: String, securityCode: String) {
        self.securityCode = securityCode
        super.init(moduleName: moduleName)
    }
    
    func lockdown(withPassword password: String) {
        if password == securityCode {
            isLockedDown = true
            print("🚀 Control Center is locked down. 🚫")
        } else {
            print("❌ Incorrect password. Control Center remains operational. ✅")
        }
    }
    
    func printInfo() {
        if !isLockedDown {
            print("🚀 Control Center is operational. ✅")
        } else {
            print("🚫 Control Center is locked down. Access denied. ❌")
        }
    }
}

class ResearchLab: StationModule {
    private var samples: [String] = []
    
    func addSample(_ sample: String) {
        samples.append(sample)
    }
    
    func examinePlanet(planet: Planet) {
        let randomIndex = Int.random(in: 0..<planet.samples.count)
        let randomSample = planet.samples[randomIndex]
        print("🔬 Research Lab is examining the planet \(planet.name). 🌍 Random sample collected: \(randomSample) 🧪")
        addSample(randomSample)
    }
}

class LifeSupportSystem: StationModule {
    private var oxygenLevel: Int = 100
    
    func reportOxygenStatus(planet: Planet) {
        print("🌬️ Life Support System reports oxygen level is \(planet.oxygenLevel)% on the planet \(planet.name). 💨")
    }
}

class Drone {
    var task: String?
    unowned var assignedModule: StationModule
    weak var missionControlLink: MissionControl?
    
    init(assignedModule: StationModule) {
        self.assignedModule = assignedModule
    }
    
    func checkTaskStatus() {
        if let task = task {
            print("🤖 Drone in module \(assignedModule.moduleName) is performing task: \(task) 🛰️")
        } else {
            print("🤖 Drone in module \(assignedModule.moduleName) is idle. 🌙")
        }
    }
}

class OrbitronSpaceStation {
    let controlCenter: ControlCenter
    let researchLab: ResearchLab
    let lifeSupportSystem: LifeSupportSystem
    var lockdownEnabled: Bool = false
    var planet: Planet
    
    init(controlCenter: ControlCenter, researchLab: ResearchLab, lifeSupportSystem: LifeSupportSystem, planet: Planet) {
        self.controlCenter = controlCenter
        self.researchLab = researchLab
        self.lifeSupportSystem = lifeSupportSystem
        self.planet = planet
        
        // Assign drones to modules
        controlCenter.assignDrone(drone: Drone(assignedModule: controlCenter))
        researchLab.assignDrone(drone: Drone(assignedModule: researchLab))
        lifeSupportSystem.assignDrone(drone: Drone(assignedModule: lifeSupportSystem))
    }
    
    func toggleLockdown(withPassword password: String) {
        if lockdownEnabled {
            print("🚀 Control Center is already locked down. 🚫")
        } else {
            controlCenter.lockdown(withPassword: password)
            lockdownEnabled = controlCenter.isLockedDown
        }
    }
    
    func observePlanet() {
        print("🔭 Orbitron Space Station is observing the planet \(planet.name). ")
        
        // Collect a random sample
        researchLab.examinePlanet(planet: planet)
        
        // Report oxygen leVel
        lifeSupportSystem.reportOxygenStatus(planet: planet)
    }
}

class MissionControl {
    var spaceStation: OrbitronSpaceStation?
    
    func connectToSpaceStation(spaceStation: OrbitronSpaceStation) {
        self.spaceStation = spaceStation
    }
    
    func requestControlCenterStatus() {
        spaceStation?.controlCenter.printInfo()
    }
    
    func requestOxygenStatus() {
        spaceStation?.lifeSupportSystem.reportOxygenStatus(planet: spaceStation!.planet)
    }
    
    func requestDroneStatus(module: StationModule) {
        module.drone?.checkTaskStatus()
    }
}

let mars = Planet(name: "Saturn 🪐", samples: ["Water Sample", "Soil Sample", "Rock Sample"], oxygenLevel: 65)

let controlCenter = ControlCenter(moduleName: "Control Center", securityCode: "password123")
let researchLab = ResearchLab(moduleName: "Research Lab")
let lifeSupportSystem = LifeSupportSystem(moduleName: "Life Support System")

let orbitronSpaceStation = OrbitronSpaceStation(controlCenter: controlCenter, researchLab: researchLab, lifeSupportSystem: lifeSupportSystem, planet: mars)

let missionControl = MissionControl()

missionControl.connectToSpaceStation(spaceStation: orbitronSpaceStation)

missionControl.requestControlCenterStatus()

orbitronSpaceStation.observePlanet()

controlCenter.drone?.task = "Data Collection"
researchLab.drone?.task = "Sample Analysis"
lifeSupportSystem.drone?.task = "Oxygen Maintenance"

missionControl.requestDroneStatus(module: researchLab)
missionControl.requestDroneStatus(module: lifeSupportSystem)

// Test the .toggleLockdown function
orbitronSpaceStation.toggleLockdown(withPassword: "password123")

// Request control center status after attempting to toggle lockdown
missionControl.requestControlCenterStatus()



