-- ============================================================
-- CONFIGURATION RAGEUI V2 - ESX_MULTICHARACTER
-- ============================================================
-- Ce fichier centralise l'apparence, la position, les touches
-- et les textes du menu multicharacter.
--
-- Les touches utilisent les IDs de contrôles GTA/FiveM.
-- Valeurs par défaut :
--   Haut = 172 | Bas = 173 | Gauche = 174 | Droite = 175
--   Valider = 201 | Retour = 177
-- ============================================================

Config.RageUI = {
    Menu = {
        -- Titre affiché dans la bannière RageUI.
        Title = 'T STUDIO',

        -- Position du menu à l'écran.
        Position = {
            X = 20,
            Y = 20
        },

        -- Couleurs RGB du thème.
        Colors = {
            -- Couleur du bouton actuellement sélectionné.
            SelectedButton = { R = 190, G = 20, B = 20 },

            -- Couleur principale du dégradé de bannière.
            BannerGradient = { R = 255, G = 0, B = 0 },

            -- Couleur rectangulaire optionnelle de bannière.
            -- Active = true remplace le dégradé/sprite par cette couleur.
            RectangleBanner = {
                Active = false,
                R = 190,
                G = 20,
                B = 20,
                A = 255
            }
        },

        -- false = le joueur ne peut pas fermer le menu avec Retour/Échap.
        Closable = false,

        -- Nombre maximum d'éléments visibles par page.
        MaxVisibleItems = 13
    },

    Controls = {
        Up = 172,
        Down = 173,
        Left = 174,
        Right = 175,
        Select = 201,
        Back = 177,

        -- Contrôles supplémentaires autorisés pendant que le jeu est bloqué
        -- sur l'écran de sélection des personnages.
        ExtraEnabled = {
            18, 27, 187, 188, 191, 108, 109, 209, 19
        }
    },

    Texts = {
        MainSubtitle = 'Sélectionnez votre personnage',
        OptionsSubtitle = 'Options du personnage',
        DeleteSubtitle = 'Confirmation de suppression',

        SelectCharacter = 'Sélectionnez votre personnage',
        CreateCharacter = 'Créer un personnage',
        PlayCharacter = 'Jouer',
        PlayCharacterDescription = 'Jouer avec ce personnage.',
        DisabledCharacter = 'Personnage désactivé',
        DisabledCharacterDescription = 'Ce personnage est actuellement désactivé.',
        DeleteCharacter = 'Supprimer le personnage',
        DeleteCharacterDescription = 'Supprimer définitivement ce personnage.',
        DeleteConfirmDescription = 'Confirmer la suppression définitive du personnage.',
        Return = 'Retour',
        ReturnDescription = 'Revenir aux options du personnage.',
        CharacterDescription = 'Métier : %s | Banque : $%s | Liquide : $%s',
        CharacterRightLabel = '→→',
        Disabled = 'Désactivé',
        NoJob = 'Aucun',

        CreateCharacterDescription = 'Créer un nouveau personnage dans un emplacement libre.',
        CreateCharacterRightLabel = '+',

        CharacterNotFound = 'Personnage introuvable',
        JobAndGrade = 'Métier : ~r~%s~s~ | Grade : ~r~%s~s~',
        BirthDate = 'Date de naissance : ~r~%s~s~',
        Money = 'Banque : ~b~$%s~s~ | Liquide : ~g~$%s~s~',
        Sex = 'Sexe : ~r~%s~s~',
        Unknown = 'Inconnu',
        UnknownFemale = 'Inconnue',

        PlayRightLabel = '→',
        DisabledRightLabel = '~r~X',
        DeleteRightLabel = '~r~X',

        DeleteWarning = '~r~ATTENTION~s~',
        DeleteQuestion = 'Supprimer %s %s ?',
        DeleteIrreversible = 'Cette action est irréversible.',
        DeleteConfirm = 'Oui, supprimer',
        DeleteConfirmRightLabel = '~r~X',
        ReturnRightLabel = '←'
    }
}
