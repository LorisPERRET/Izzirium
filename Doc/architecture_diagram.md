flowchart TD
    App[IzziriumApp]

    subgraph Presentation[Presentation - SwiftUI]
        Root[RootCoordinatorView]
        Screens[Ecrans et ViewModels<br/>Login, Aquarium, Configuration BLE, Settings]
    end

    subgraph Domain[Domain]
        UseCases[Use Cases<br/>Login, Session, Aquarium, Pairing BLE, Alerts]
        Managers[Managers metier<br/>PairingManager]
        Models[Modeles metier et etats]
    end

    subgraph Data[Data]
        Repos[Repositories<br/>UserRepository, AquariumRepository, AlertRepository, LogRepository]
    end

    subgraph Sources[Sources de donnees]
        Remote[Remote Data Sources<br/>API HTTP]
        Local[Local Data Sources<br/>Keychain, UserDefaults, Base locale]
        BLE[BLE Layer<br/>BlePairingCentralManager]
    end

    subgraph External[Dependances externes]
        Apple[Frameworks Apple<br/>SwiftUI, CoreBluetooth, AuthenticationServices]
        ThirdParty[SKDevKit, PapyrusAlamofire, Kastor]
        Backend[Backend]
        Sensor[Capteur BLE]
    end

    App --> Root
    Root --> Screens
    Screens --> UseCases
    Screens --> Managers

    UseCases --> Repos
    Managers --> BLE
    UseCases --> Models
    Managers --> Models

    Repos --> Remote
    Repos --> Local

    Remote --> Backend
    BLE --> Sensor

    Presentation -. utilise .-> Apple
    Domain -. utilise .-> ThirdParty
    Data -. utilise .-> ThirdParty
    BLE -. s'appuie sur .-> Apple
