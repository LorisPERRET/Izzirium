sequenceDiagram
    autonumber

    actor U as Utilisateur
    participant App as Application mobile
    participant Apple as Sign in with Apple
    participant API as Backend
    participant Storage as Stockage local

    U->>App: Appuie sur "Se connecter avec Apple"
    App->>Apple: Demande d'authentification
    Apple-->>App: Retourne identite Apple + identityToken

    App->>API: Envoie identityToken + email
    API-->>App: Retourne token de session

    App->>Storage: Sauvegarde token, refreshToken, expiration, userId et email
    App-->>U: Ouvre l'application en mode connecte

    alt Echec d'authentification
        Apple-->>App: Erreur ou token invalide
        App-->>U: Affiche une erreur
    else Echec backend
        API-->>App: Refus ou erreur serveur
        App-->>U: Affiche une erreur
    end
