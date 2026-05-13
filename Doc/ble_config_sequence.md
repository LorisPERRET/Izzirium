sequenceDiagram
    autonumber

    actor U as Utilisateur
    participant App as Application mobile
    participant API as Backend
    participant Sensor as Capteur BLE

    U->>App: Cree un aquarium
    App->>API: Demande creation
    API-->>App: Retourne secretSensorId

    U->>App: Ouvre l'ecran de configuration
    App->>Sensor: Lance un scan BLE
    Sensor-->>App: Se signale comme disponible

    U->>App: Selectionne le capteur et saisit le Wi-Fi
    App->>Sensor: Se connecte en BLE
    App->>Sensor: Envoie SSID + mot de passe + sensorId

    Sensor-->>App: Envoie les etats de configuration
    Note over Sensor,App: envoi credentials -> connexion reseau -> enregistrement backend

    alt Configuration reussie
        Sensor-->>App: Statut succes
        App-->>U: Confirme la configuration
    else Configuration echouee
        Sensor-->>App: Statut erreur
        App-->>U: Affiche une erreur
    end
