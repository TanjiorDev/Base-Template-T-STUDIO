// ============================================================
//  BLOODADMIN — HTML/JS/STATE.JS
// ============================================================

let state = {
    players:[], offlinePlayers:[], playersFilter:'online', staff:[], allStaff:[], selectedPlayer:null, selectedGrade:null,
    permissions:{}, allResources:[],
    myGrade:'', myPerms: {}, myDuty: false,
    myName: '', myId: 0,
    logs: [],
    staffChat: [],
    banReasons:[], banDurations:[], dashFilter:'all', config:{},
    lastReportCount: 0
};

function formatMoney(n) {
    return new Intl.NumberFormat('fr-FR', { style: 'currency', currency: 'EUR', maximumFractionDigits: 0 }).format(n).replace('€', '$');
}

function checkDuty() {
    if (!state.myDuty) {
        if (typeof showToast === 'function') {
            showToast('Vous devez être EN SERVICE pour effectuer cette action.', 'error');
        }
        return false;
    }
    return true;
}

const $ = id => document.getElementById(id);

const esc = t => t ? t.toString().replace(/[&<>"']/g, m => ({
    '&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'
}[m])) : '';

function sendToClient(action, data = {}, cb) {
    fetch(`https://${GetParentResourceName()}/${action}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
    })
    .then(resp => resp.json())
    .then(respData => {
        if (cb) cb(respData);
    })
    .catch(err => {
        if (cb) cb(null);
    });
}

const pageTitles = {
    'dashboard':   ['Tableau de Bord', 'Aperçu global du serveur'],
    'players':     ['Gestion Joueurs', 'Actions en temps réel sur la population'],
    'sanctions':   ['Liste Noire', 'Gestion des bannissements et avertissements'],
    'resources':   ['Ressources', 'Contrôle technique du serveur'],
    'permissions': ['Permissions', 'Équipe administrative et grades'],
    'tools':       ['Outils Admin', 'Fonctions rapides et noclip'],
    'economy':     ['Économie', 'Gestion de la monnaie et inventaire'],
    'world':       ['Monde', 'Climat, temps et entités globales'],
    'console':     ['Console RCON', 'Exécution de commandes directes'],
    'logs':        ['Logs Serveur', 'Historique complet des actions administratives'],
    'reports':     ['Centre de Signalement', 'Gestion des tickets et assistance aux joueurs'],
    'staffmode':   ['Espace Staff', 'Outils de modération rapide et service'],
    'staff':       ['Staff en Ligne', 'Liste des modérateurs connectés'],
    'vehicles':    ['Gestion Véhicules', 'Contrôle, catalogue et customisation de la flotte']
};

function getPingClass(p) {
    if (p < 80) return 'ping-ok';
    if (p < 150) return 'ping-warn';
    return 'ping-bad';
}
