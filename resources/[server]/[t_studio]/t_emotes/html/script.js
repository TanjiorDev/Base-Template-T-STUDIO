// ==========================================
// VARIABLES GLOBALES
// ==========================================
let emotesData = { 
    Emotes: [], Dances: [], Props: [], Shared: [], Walks: [], 
    DeadoV2: [], Others: [], LAChicago: [], Stacking: [],
    AnimalEmotes: [], Expressions: []
};

let currentCategory = 'Emotes';
let favorites = JSON.parse(localStorage.getItem('kzb_favorites')) || [];
let listToRenderGlobal = []; 
let currentContextEmoteId = null;

// ==========================================
// RÉCEPTION DES MESSAGES DU JEU (LUA -> JS)
// ==========================================
window.addEventListener('message', function(event) {
    let data = event.data;
    if (data.action === "open") {
        document.body.style.display = "block";
        emotesData = data.emotes; 
        document.getElementById('search-bar').value = '';
        switchCategory(currentCategory); 
    } else if (data.action === "close") {
        document.body.style.display = "none";
        hideContextMenu();
    }
});

// ==========================================
// GESTION DES CATÉGORIES (BARRE LATÉRALE)
// ==========================================
document.querySelectorAll('.cat-btn').forEach(btn => {
    btn.addEventListener('click', function() {
        document.querySelectorAll('.cat-btn').forEach(b => b.classList.remove('active'));
        this.classList.add('active');
        currentCategory = this.getAttribute('data-cat');
        document.getElementById('search-bar').value = ''; 
        switchCategory(currentCategory);
    });
});

function switchCategory(cat, searchTerm = "") {
    let listToRender = [];

    // Regroupement de tes catégories personnalisées dans les onglets principaux
    if (cat === 'Emotes') {
        listToRender = [...(emotesData.Emotes || []), ...(emotesData.AnimalEmotes || []), ...(emotesData.Others || [])];
    } else if (cat === 'Dances') {
        listToRender = [...(emotesData.Dances || []), ...(emotesData.DeadoV2 || []), ...(emotesData.LAChicago || []), ...(emotesData.Stacking || [])];
    } else if (cat === 'Favorites') {
        let allEmotesFlat = [
            ...(emotesData.Emotes || []), ...(emotesData.Dances || []), ...(emotesData.Props || []), 
            ...(emotesData.Shared || []), ...(emotesData.Walks || []), ...(emotesData.AnimalEmotes || []), 
            ...(emotesData.Expressions || []), ...(emotesData.DeadoV2 || []), ...(emotesData.Others || []), 
            ...(emotesData.LAChicago || []), ...(emotesData.Stacking || [])
        ];
        listToRender = allEmotesFlat.filter(emote => favorites.includes(emote.id));
    } else {
        listToRender = emotesData[cat] || [];
    }

    // Gestion de la recherche
    if (searchTerm !== "") {
        listToRender = listToRender.filter(e => 
            e.label.toLowerCase().includes(searchTerm.toLowerCase()) || 
            e.id.toLowerCase().includes(searchTerm.toLowerCase())
        );
    }
    
    // Tri par ordre alphabétique
    listToRender.sort((a, b) => a.label.localeCompare(b.label));

    listToRenderGlobal = listToRender;
    renderList(true);
}

document.getElementById('search-bar').addEventListener('input', function(e) {
    switchCategory(currentCategory, e.target.value);
});

// ==========================================
// AFFICHAGE DE LA LISTE (CHARGEMENT PROGRESSIF)
// ==========================================
function renderList(clearList = true) {
    const list = document.getElementById('emotes-list');
    if (clearList) { list.innerHTML = ''; list.scrollTop = 0; }
    
    const fragment = document.createDocumentFragment();
    const startIndex = list.children.length;
    const endIndex = Math.min(startIndex + 100, listToRenderGlobal.length); // Charge 100 par 100
    if (startIndex >= endIndex) return;

    for (let i = startIndex; i < endIndex; i++) {
        let emote = listToRenderGlobal[i];
        let isFav = favorites.includes(emote.id);
        let div = document.createElement('div');
        div.className = 'emote-item';
        
        // Clic Droit Actif
        div.oncontextmenu = function(e) {
            e.preventDefault();
            showContextMenu(e.pageX, e.pageY, emote.id);
        };

        // Génération du HTML de l'item avec l'icône de l'œil
        div.innerHTML = `
            <div class="btn-fav ${isFav ? 'is-fav' : ''}" onclick="toggleFav('${emote.id}', this); event.stopPropagation();" title="Ajouter aux favoris">★</div>
            <div class="emote-label">${emote.label}</div>
            <button class="btn-play" onclick="playEmote('${emote.id}'); event.stopPropagation();" title="Jouer l'animation"><i class="fa-solid fa-play"></i></button>
            <button class="btn-preview" onclick="previewEmote('${emote.id}'); event.stopPropagation();" title="Aperçu du clone"><i class="fa-solid fa-eye"></i></button>
        `;
        fragment.appendChild(div);
    }
    list.appendChild(fragment);
}

// Événement pour charger la suite quand on scrolle vers le bas
document.getElementById('emotes-list').addEventListener('scroll', function() {
    if (this.scrollTop + this.clientHeight >= this.scrollHeight - 50) renderList(false);
});

// ==========================================
// GESTION DES FAVORIS
// ==========================================
function toggleFav(id, element) {
    if (favorites.includes(id)) { 
        favorites = favorites.filter(favId => favId !== id); 
        element.classList.remove('is-fav'); 
    } else { 
        favorites.push(id); 
        element.classList.add('is-fav'); 
    }
    localStorage.setItem('kzb_favorites', JSON.stringify(favorites));
    
    // Si on est dans la catégorie Favoris, on met à jour en temps réel
    if (currentCategory === 'Favorites') switchCategory('Favorites');
}

// ==========================================
// MENU CONTEXTUEL (CLIC DROIT)
// ==========================================
const contextMenu = document.getElementById('context-menu');

function showContextMenu(x, y, id) { 
    currentContextEmoteId = id; 
    contextMenu.style.left = `${x}px`; 
    contextMenu.style.top = `${y}px`; 
    contextMenu.classList.remove('hidden'); 
}

function hideContextMenu() { 
    contextMenu.classList.add('hidden'); 
    currentContextEmoteId = null; 
}

// Cacher le menu clic droit si on clique ailleurs
document.addEventListener('click', function(e) { 
    if (!contextMenu.contains(e.target)) hideContextMenu(); 
});

// Actions du clic droit
document.getElementById('ctx-play').addEventListener('click', () => { playEmote(currentContextEmoteId); hideContextMenu(); });
document.getElementById('ctx-preview').addEventListener('click', () => { previewEmote(currentContextEmoteId); hideContextMenu(); });
document.getElementById('ctx-place').addEventListener('click', () => { placeEmote(currentContextEmoteId); hideContextMenu(); });

// ==========================================
// ENVOI DES COMMANDES AU JEU (JS -> LUA)
// ==========================================
function previewEmote(id) { fetch(`https://${GetParentResourceName()}/previewEmote`, { method: 'POST', body: JSON.stringify({ id: id }) }); }
function playEmote(id) { fetch(`https://${GetParentResourceName()}/playEmote`, { method: 'POST', body: JSON.stringify({ id: id }) }); }
function placeEmote(id) { fetch(`https://${GetParentResourceName()}/placeEmote`, { method: 'POST', body: JSON.stringify({ id: id }) }); }
function cancelEmote() { fetch(`https://${GetParentResourceName()}/cancelEmote`, { method: 'POST', body: JSON.stringify({}) }); }
function resetPreview() { fetch(`https://${GetParentResourceName()}/resetPreview`, { method: 'POST', body: JSON.stringify({}) }); }

// Fermeture avec la touche Échap
document.onkeyup = function(data) { 
    if (data.key == 'Escape') {
        fetch(`https://${GetParentResourceName()}/closeMenu`, { method: 'POST', body: JSON.stringify({}) }); 
    }
};