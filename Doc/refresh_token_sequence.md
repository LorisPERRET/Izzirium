sequenceDiagram
    autonumber

    participant App as Application mobile
    participant Storage as Stockage local
    participant Apple as Apple Sign In
    participant API as Backend

    App->>Storage: Lit userId et date d'expiration

    alt Aucun userId
        Storage-->>App: Pas de session locale
        App-->>App: Etat non connecte
    else userId present
        App->>Apple: Verifie l'etat du compte Apple
        Apple-->>App: authorized ou non

        alt Compte Apple non valide
            App-->>App: Etat non connecte
        else Compte Apple valide
            App->>Storage: Verifie si le token d'acces est expire

            alt Token encore valide
                App-->>App: Etat connecte
            else Token expire
                App->>Storage: Lit le refreshToken
                App->>API: Demande un nouveau token
                API-->>App: Retourne accessToken + refreshToken + expiration
                App->>Storage: Met a jour les tokens et la date d'expiration
                App-->>App: Etat connecte
            end
        end
    end

    alt Echec du refresh
        API-->>App: Erreur ou refreshToken invalide
        App-->>App: Etat non connecte
    end
