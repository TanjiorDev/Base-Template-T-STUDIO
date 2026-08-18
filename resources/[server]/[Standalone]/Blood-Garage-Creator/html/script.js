/* ============================================================
   BLOODLEAK PREMIUM 2026 SPLIT GARAGE DASHBOARD — SCRIPT.JS
   ============================================================ */

let VehiclesData = [];
let SearchQuery = '';
let GarageLabel = 'GARAGE CENTRAL';
let GarageType = 'car';
let CurrentOpenGarageId = null;
let ImpoundFee = 1500;
let TransferFee = 500;
let ActiveVehicleIndex = -1; // -1 pour aucune sélection
let IsAdmin = false;
let ImpoundsList = {};
let ActiveSpawnPoints = [];
let CurrentSelectingSpawnIndex = -1;

const AppContainer = document.getElementById('garage-app');
const SearchInput = document.getElementById('search-input');
const ListContainer = document.getElementById('vehicle-list-container');
const CountIndicator = document.getElementById('vehicle-count');

const EmptyPrompt = document.getElementById('empty-prompt');
const DetailsContent = document.getElementById('details-content');
const ActionSpawnBtn = document.getElementById('action-spawn-btn');

// 1. Écouteur de messages NUI (Depuis FiveM Client)
window.addEventListener('message', function(event) {
    const data = event.data;

    if (data.action === "open") {
        GarageLabel = data.garageLabel || "GARAGE";
        GarageType = data.garageType || "car";
        CurrentOpenGarageId = data.currentGarageId || null;
        VehiclesData = data.vehicles || [];
        ImpoundFee = data.impoundFee || 1500;
        TransferFee = data.transferFee || 500;
        IsAdmin = data.isAdmin || false;
        ImpoundsList = data.impoundsList || {};

        // Configuration textuelle
        document.getElementById('garage-title').innerText = GarageLabel.toUpperCase();
        
        let typeText = "VOITURES";
        if (GarageType === "boat") typeText = "BATEAUX";
        else if (GarageType === "air") typeText = "AÉRONEFS";
        else if (GarageType === "helicopter") typeText = "HÉLICOPTÈRES";
        else if (GarageType === "impound") typeText = "FOURRIÈRE VOITURES";
        else if (GarageType === "impound_boat") typeText = "FOURRIÈRE BATEAUX";
        else if (GarageType === "impound_air") typeText = "FOURRIÈRE AÉRONEFS";
        else if (GarageType === "impound_helicopter") typeText = "FOURRIÈRE HÉLICOPTÈRES";
        document.getElementById('garage-type-badge').innerText = typeText;

        // Gérer la visibilité du bouton Admin
        const adminBtn = document.getElementById('admin-toggle-btn');
        if (IsAdmin) {
            adminBtn.classList.remove('hidden');
        } else {
            adminBtn.classList.add('hidden');
        }

        // S'assurer que le panneau admin est masqué à l'ouverture
        const adminPanel = document.getElementById('admin-panel');
        adminPanel.classList.remove('show');
        adminPanel.classList.add('hidden');

        // Réinitialiser la sélection et les fenêtres
        ActiveVehicleIndex = -1;
        EmptyPrompt.classList.remove('hidden');
        DetailsContent.classList.add('hidden');

        // Afficher l'application avec animation
        AppContainer.classList.remove('hidden');
        setTimeout(() => {
            AppContainer.classList.add('show');
        }, 30);

        // Réinitialiser la recherche
        SearchQuery = '';
        SearchInput.value = '';
        
        renderVehicleList();
    } else if (data.action === "close") {
        closeGarage();
    } else if (data.action === "tempHide") {
        AppContainer.classList.add('temp-hidden');
        
        // Show premium volcanic selection overlay
        const selectionOverlay = document.getElementById('selection-overlay');
        if (selectionOverlay) {
            const subtitle = document.getElementById('selection-subtitle');
            if (subtitle) {
                let labelType = "Spawn Véhicule";
                if (data.type === "ped") {
                    labelType = "Position du PNJ (Garagiste)";
                } else if (data.type === "delete") {
                    labelType = "Zone de Rangement du Véhicule";
                }
                subtitle.innerText = `Placement: ${labelType}`;
            }
            selectionOverlay.classList.remove('hidden');
        }
    } else if (data.action === "tempRestore") {
        AppContainer.classList.remove('temp-hidden');
        
        // Hide selection overlay
        const selectionOverlay = document.getElementById('selection-overlay');
        if (selectionOverlay) {
            selectionOverlay.classList.add('hidden');
        }
    } else if (data.action === "coordsSelected") {
        const coords = data.coords || { x: 0.0, y: 0.0, z: 0.0, w: 0.0 };
        if (data.type === 'ped') {
            document.getElementById('coord-ped-x').value = coords.x.toFixed(2);
            document.getElementById('coord-ped-y').value = coords.y.toFixed(2);
            document.getElementById('coord-ped-z').value = coords.z.toFixed(2);
            document.getElementById('coord-ped-h').value = coords.w.toFixed(2);
        } else if (data.type === 'spawn') {
            if (CurrentSelectingSpawnIndex !== -1) {
                const idx = CurrentSelectingSpawnIndex;
                if (ActiveSpawnPoints[idx]) {
                    ActiveSpawnPoints[idx] = { x: coords.x, y: coords.y, z: coords.z, w: coords.w };
                    renderSpawnPointsList();
                }
                CurrentSelectingSpawnIndex = -1;
            }
        } else if (data.type === 'delete') {
            document.getElementById('coord-delete-x').value = coords.x.toFixed(2);
            document.getElementById('coord-delete-y').value = coords.y.toFixed(2);
            document.getElementById('coord-delete-z').value = coords.z.toFixed(2);
        }
    } else if (data.action === "openMasterAdmin") {
        GarageLabel = "ADMINISTRATION GLOBALE";
        IsAdmin = true;
        CurrentOpenGarageId = null;
        ImpoundsList = data.impoundsList || {};
        
        // Display main app wrapper and immediately show admin panel
        AppContainer.classList.remove('hidden');
        setTimeout(() => { AppContainer.classList.add('show'); }, 30);
        
        populateImpoundSelect();
        AdminPanel.classList.remove('hidden');
        setTimeout(() => { AdminPanel.classList.add('show'); }, 10);
        
        // Hide vehicle list contents to indicate admin focus
        ListContainer.innerHTML = `<div style="text-align: center; color: var(--text-dark); padding: 40px 10px;">Interface d'administration active</div>`;
    }
});

// 2. Fermer le garage
function closeGarage() {
    AppContainer.classList.remove('show');
    setTimeout(() => {
        AppContainer.classList.add('hidden');
        // Envoyer le callback au client pour fermer le focus NUI
        fetch(`https://${GetParentResourceName()}/close`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({})
        });
    }, 300);
}

// Helper pour jouer le son de survol
function playHoverSound() {
    fetch(`https://${GetParentResourceName()}/playHoverSound`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    }).catch(err => {});
}

// Helper pour jouer le son de sélection
function playSelectSound() {
    fetch(`https://${GetParentResourceName()}/playSelectSound`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    }).catch(err => {});
}

// Helper pour obtenir la couleur de la barre de vie
function getHealthGradient(val) {
    if (val >= 75) {
        return 'linear-gradient(90deg, #10b981, #34d399)'; // Vert Émeraude Lumineux
    } else if (val >= 35) {
        return 'linear-gradient(90deg, #f59e0b, #fbbf24)'; // Orange Ambré
    } else {
        return 'linear-gradient(90deg, #ef4444, #f87171)'; // Rouge Rubis
    }
}

// 3. Générer la liste des véhicules (Gauche)
function renderVehicleList() {
    ListContainer.innerHTML = '';

    // Filtrer la liste en fonction de la recherche
    const filtered = VehiclesData.filter(veh => {
        const matchesSearch = veh.label.toLowerCase().includes(SearchQuery.toLowerCase()) || 
                              veh.plate.toLowerCase().includes(SearchQuery.toLowerCase());
        return matchesSearch;
    });

    // Mettre à jour le compteur de pieds de page
    CountIndicator.innerText = `${filtered.length} VÉHICULE${filtered.length > 1 ? 'S' : ''}`;

    if (filtered.length === 0) {
        ListContainer.innerHTML = `
            <div style="text-align: center; color: var(--text-dark); padding: 40px 10px; font-size: 12px;">
                <i class="fa-solid fa-ban" style="font-size: 20px; margin-bottom: 6px; display: block; opacity: 0.5;"></i>
                Aucun véhicule
            </div>
        `;
        return;
    }

    // Créer les lignes pour chaque véhicule
    filtered.forEach((veh, index) => {
        const item = document.createElement('div');
        item.className = 'veh-row';
        
        if (ActiveVehicleIndex === index) {
            item.classList.add('active');
        }
        
        // Statut micro indicateur dot
        let statusDotClass = 'stored';
        if (veh.statusRaw === 'impound') {
            statusDotClass = 'impound';
        } else if (veh.statusRaw !== 'stored') {
            statusDotClass = 'out';
        }

        // Déterminer la catégorie
        let catIcon = '<i class="fa-solid fa-car"></i>';
        let catLabel = 'TERRESTRE';
        if (veh.class === 14) {
            catIcon = '<i class="fa-solid fa-ship"></i>';
            catLabel = 'MARITIME';
        } else if (veh.class === 15) {
            catIcon = '<i class="fa-solid fa-helicopter"></i>';
            catLabel = 'HÉLICOPTÈRE';
        } else if (veh.class === 16) {
            catIcon = '<i class="fa-solid fa-plane"></i>';
            catLabel = 'AVION';
        }

        item.innerHTML = `
            <div class="row-left">
                <span class="row-name">${veh.label}</span>
                <div style="display: flex; align-items: center; gap: 8px; margin-top: 3px;">
                    <span class="row-plate">${veh.plate}</span>
                    <span class="row-category-badge" style="font-size: 8px; font-weight: 700; color: var(--primary); background: rgba(185, 28, 28, 0.12); padding: 2px 6px; border-radius: 3px; display: inline-flex; align-items: center; gap: 3px;">
                        ${catIcon} ${catLabel}
                    </span>
                </div>
            </div>
            <div class="row-right">
                <span class="status-dot ${statusDotClass}"></span>
            </div>
        `;

        // Son de survol désactivé pour éviter le spam de clics

        // Écouteur pour charger les détails à droite lors du clic
        item.addEventListener('click', function() {
            ActiveVehicleIndex = index;
            playSelectSound();
            
            // Mettre à jour la classe active sur les lignes
            const rows = ListContainer.querySelectorAll('.veh-row');
            rows.forEach(r => r.classList.remove('active'));
            item.classList.add('active');

            renderVehicleDetails(veh);
        });

        ListContainer.appendChild(item);
    });
}

// 4. Générer le panneau des détails (Droite)
function renderVehicleDetails(veh) {
    EmptyPrompt.classList.add('hidden');
    DetailsContent.classList.remove('hidden');

    // Mettre à jour les textes basiques
    document.getElementById('detail-name').innerText = veh.label.toUpperCase();
    document.getElementById('detail-plate').innerText = veh.plate.toUpperCase();

    // Mettre à jour l'icône holographique selon la catégorie du véhicule
    const previewIcon = document.querySelector('.preview-car-icon');
    const vehicleImg = document.getElementById('preview-vehicle-img');
    
    if (previewIcon) {
        previewIcon.className = 'fa-solid preview-car-icon';
        if (veh.class === 14) {
            previewIcon.classList.add('fa-ship');
        } else if (veh.class === 15) {
            previewIcon.classList.add('fa-helicopter');
        } else if (veh.class === 16) {
            previewIcon.classList.add('fa-plane');
        } else {
            previewIcon.classList.add('fa-car-side');
        }
    }

    if (vehicleImg && previewIcon) {
        if (veh.modelName && veh.modelName !== 'unknown') {
            // Masquer temporairement pour éviter le clignotement de l'ancien véhicule
            vehicleImg.classList.add('hidden');
            previewIcon.classList.add('hidden');
            
            // Lancer le chargement asynchrone depuis le CDN
            vehicleImg.src = `https://cdn.jsdelivr.net/gh/Stuyk/gtav-image-archive/vehicles/${veh.modelName.toLowerCase()}.webp`;
            
            vehicleImg.onload = function() {
                vehicleImg.classList.remove('hidden');
                previewIcon.classList.add('hidden');
            };
            vehicleImg.onerror = function() {
                vehicleImg.classList.add('hidden');
                previewIcon.classList.remove('hidden');
            };
        } else {
            vehicleImg.classList.add('hidden');
            previewIcon.classList.remove('hidden');
        }
    }

    // Statut badge
    const statusBadge = document.getElementById('detail-status');
    statusBadge.className = 'status-badge';
    
    if (veh.statusRaw === 'stored') {
        statusBadge.innerText = 'Rangé';
        statusBadge.classList.add('stored');
    } else if (veh.statusRaw === 'impound') {
        statusBadge.innerText = 'Fourrière';
        statusBadge.classList.add('impound');
    } else if (veh.statusRaw === 'other_garage') {
        statusBadge.innerText = 'Rangé Ailleurs';
        statusBadge.classList.add('other');
    } else {
        statusBadge.innerText = 'Dehors';
        statusBadge.classList.add('out');
    }

    // Télémétrie Moteur
    const engineVal = document.getElementById('stat-engine-val');
    const engineBar = document.getElementById('stat-engine-bar');
    engineVal.innerText = `${veh.engineHealth}%`;
    engineBar.style.width = `0%`; // Commencer à 0 pour l'animation
    setTimeout(() => {
        engineBar.style.width = `${veh.engineHealth}%`;
        engineBar.style.background = 'linear-gradient(90deg, #b91c1c, #ef4444)';
    }, 50);

    // Télémétrie Carburant
    const fuelVal = document.getElementById('stat-fuel-val');
    const fuelBar = document.getElementById('stat-fuel-bar');
    fuelVal.innerText = `${veh.fuel}%`;
    fuelBar.style.width = `0%`; // Commencer à 0 pour l'animation
    setTimeout(() => {
        fuelBar.style.width = `${veh.fuel}%`;
        fuelBar.style.background = 'linear-gradient(90deg, #b91c1c, #ef4444)';
    }, 100);

    // Télémétrie Carrosserie
    const bodyVal = document.getElementById('stat-body-val');
    const bodyBar = document.getElementById('stat-body-bar');
    const bodyHealthReal = veh.bodyHealth || 100;
    bodyVal.innerText = `${bodyHealthReal}%`;
    bodyBar.style.width = `0%`; // Commencer à 0 pour l'animation
    setTimeout(() => {
        bodyBar.style.width = `${bodyHealthReal}%`;
        bodyBar.style.background = 'linear-gradient(90deg, #b91c1c, #ef4444)';
    }, 150);

    // Configuration du gros bouton d'action
    const isImpoundGarage = (GarageType === "impound" || GarageType === "impound_boat" || GarageType === "impound_air" || GarageType === "impound_helicopter");
    
    // Récupérer le conteneur d'actions de manière dynamique
    const actionContainer = document.getElementById('action-container');
    actionContainer.innerHTML = ''; // Nettoyer les anciens boutons
    actionContainer.style.display = 'flex';
    actionContainer.style.gap = '10px';

    if (isImpoundGarage) {
        // Mode Fourrière
        if (veh.statusRaw === 'out' || veh.statusRaw === 'impound' || veh.statusRaw === 'other_garage') {
            const btn = document.createElement('button');
            btn.className = 'action-btn impound-action';
            btn.style.flex = '1';
            btn.innerHTML = `<i class="fa-solid fa-credit-card"></i> RÉCUPÉRER (${ImpoundFee}$)`;
            btn.addEventListener('click', function() {
                playSelectSound();
                retrieveVehicleFromImpound(veh.plate);
            });
            actionContainer.appendChild(btn);
        } else {
            const btn = document.createElement('button');
            btn.className = 'action-btn disabled';
            btn.style.flex = '1';
            btn.innerHTML = `<i class="fa-solid fa-ban"></i> DÉJÀ RANGÉ`;
            actionContainer.appendChild(btn);
        }
    } else {
        // Mode Garage Classique
        if (veh.statusRaw === 'stored') {
            const btn = document.createElement('button');
            btn.className = 'action-btn';
            btn.style.flex = '1';
            btn.innerHTML = `<i class="fa-solid fa-key"></i> SORTIR LE VÉHICULE`;
            btn.addEventListener('click', function() {
                playSelectSound();
                spawnVehicle(veh.plate);
            });
            actionContainer.appendChild(btn);
        } else if (veh.statusRaw === 'other_garage') {
            const btn = document.createElement('button');
            btn.className = 'action-btn impound-action';
            btn.style.flex = '1';
            
            // Récupérer le nom convivial du garage d'origine au lieu de son ID brut
            const originalGarageObj = ImpoundsList[veh.originalGarage];
            const garageName = (originalGarageObj && originalGarageObj.label) ? originalGarageObj.label : (veh.originalGarage || 'AUTRE GARAGE');
            btn.innerHTML = `<i class="fa-solid fa-truck-ramp-box"></i> LIVRER DEPUIS ${garageName.toUpperCase()} (${TransferFee}$)`;
            btn.addEventListener('click', function() {
                playSelectSound();
                transferVehicle(veh.plate);
            });
            actionContainer.appendChild(btn);
        } else if (veh.statusRaw === 'impound') {
            const btn = document.createElement('button');
            btn.className = 'action-btn disabled';
            btn.style.flex = '1';
            btn.innerHTML = `<i class="fa-solid fa-ban"></i> VÉHICULE EN FOURRIÈRE`;
            actionContainer.appendChild(btn);
        } else {
            // Un seul bouton pour localiser, et un bouton grisé pour indiquer que le véhicule est dehors
            
            // Bouton 1 : Grisé (DEHORS)
            const btnSpawn = document.createElement('button');
            btnSpawn.className = 'action-btn disabled';
            btnSpawn.style.flex = '1';
            btnSpawn.innerHTML = `<i class="fa-solid fa-ban"></i> VÉHICULE DEHORS`;
            
            // Bouton 2 : Localiser sur GPS
            const btnTrack = document.createElement('button');
            btnTrack.className = 'action-btn track-action';
            btnTrack.style.flex = '1';
            btnTrack.innerHTML = `<i class="fa-solid fa-location-crosshairs"></i> LOCALISER`;
            btnTrack.addEventListener('click', function() {
                playSelectSound();
                fetch(`https://${GetParentResourceName()}/trackVehicle`, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ plate: veh.plate })
                }).then(resp => resp.json())
                  .then(data => {
                      if (data.success) {
                          closeGarage();
                      }
                  });
            });
            
            actionContainer.appendChild(btnSpawn);
            actionContainer.appendChild(btnTrack);
        }
    }
}

// 5. Sortir le véhicule (Client FiveM)
function spawnVehicle(plate) {
    fetch(`https://${GetParentResourceName()}/spawnVehicle`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ plate: plate })
    }).then(resp => resp.json())
      .then(data => {
          if (data.success) {
              closeGarage();
          }
      });
}

// 5b. Transférer le véhicule (Client FiveM)
function transferVehicle(plate) {
    fetch(`https://${GetParentResourceName()}/transferVehicle`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ plate: plate })
    }).then(resp => resp.json())
      .then(data => {
          if (data.success) {
              closeGarage();
          }
      });
}

// 6. Récupérer le véhicule (Client FiveM)
function retrieveVehicleFromImpound(plate) {
    fetch(`https://${GetParentResourceName()}/retrieveImpound`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ plate: plate })
    }).then(resp => resp.json())
      .then(data => {
          if (data.success) {
              closeGarage();
          }
      });
}

// 7. Écouteurs pour la recherche
SearchInput.addEventListener('input', function(e) {
    SearchQuery = e.target.value;
    ActiveVehicleIndex = -1;
    EmptyPrompt.classList.remove('hidden');
    DetailsContent.classList.add('hidden');
    renderVehicleList();
});

// 8. Touche Échap pour quitter
document.addEventListener('keydown', function(event) {
    if (event.key === "Escape") {
        closeGarage();
    }
});

// ============================================================
// LOGIQUE DE CONFIGURATION ADMINISTRATIVE DES FOURRIÈRES
// ============================================================

const AdminPanel = document.getElementById('admin-panel');
const AdminToggleBtn = document.getElementById('admin-toggle-btn');
const AdminCloseBtn = document.getElementById('admin-close-btn');
const AdminImpoundSelect = document.getElementById('admin-impound-select');
const AdminLabelInput = document.getElementById('admin-label-input');
const AdminPedSelect = document.getElementById('admin-ped-select');
const AdminSaveBtn = document.getElementById('admin-save-btn');

const AcquirePedBtn = document.getElementById('acquire-ped-btn');
const AcquireSpawnBtn = document.getElementById('acquire-spawn-btn');
const AcquireDeleteBtn = document.getElementById('acquire-delete-btn');
const SelectPedBtn = document.getElementById('select-ped-btn');
const SelectSpawnBtn = document.getElementById('select-spawn-btn');
const SelectDeleteBtn = document.getElementById('select-delete-btn');

// Ouvrir le panneau d'administration
AdminToggleBtn.addEventListener('click', function() {
    playSelectSound();
    
    // Remplir le dropdown des fourrières
    populateImpoundSelect();
    
    // Résolution du conflit de classes : enlever 'hidden' d'abord, puis animer avec 'show'
    AdminPanel.classList.remove('hidden');
    setTimeout(() => {
        AdminPanel.classList.add('show');
    }, 10);
});

// Fermer le panneau d'administration
AdminCloseBtn.addEventListener('click', function() {
    playSelectSound();
    AdminPanel.classList.remove('show');
    // Mettre 'hidden' après la fin de la transition (400ms)
    setTimeout(() => {
        AdminPanel.classList.add('hidden');
    }, 400);
});

// Remplir le sélecteur de fourrières / garages avec optgroups
function populateImpoundSelect() {
    AdminImpoundSelect.innerHTML = '';
    
    // Catégoriser les points
    const groups = {
        car: { label: 'Garages Voitures', items: [] },
        boat: { label: 'Garages Bateaux', items: [] },
        air: { label: 'Garages Aéronefs', items: [] },
        helicopter: { label: 'Garages Hélicoptères', items: [] },
        impound: { label: 'Fourrières Voitures', items: [] },
        impound_boat: { label: 'Fourrières Bateaux', items: [] },
        impound_air: { label: 'Fourrières Aéronefs', items: [] },
        impound_helicopter: { label: 'Fourrières Hélicoptères', items: [] }
    };
    
    for (const [id, imp] of Object.entries(ImpoundsList)) {
        const type = imp.type || 'car';
        if (groups[type]) {
            groups[type].items.push({ id: id, label: imp.label });
        } else {
            groups.car.items.push({ id: id, label: imp.label });
        }
    }
    
    // Ajouter les groupes dans le select
    for (const [key, group] of Object.entries(groups)) {
        if (group.items.length > 0) {
            const optgroup = document.createElement('optgroup');
            optgroup.label = group.label.toUpperCase();
            
            group.items.forEach(item => {
                const opt = document.createElement('option');
                opt.value = item.id;
                opt.innerText = item.label;
                optgroup.appendChild(opt);
            });
            
            AdminImpoundSelect.appendChild(optgroup);
        }
    }
    
    // Groupe [ NOUVEAU POINT ]
    const optgroupNew = document.createElement('optgroup');
    optgroupNew.label = 'CRÉATION';
    const newOpt = document.createElement('option');
    newOpt.value = 'NEW_IMPOUND';
    newOpt.innerText = ' [ NOUVEAU POINT ]';
    optgroupNew.appendChild(newOpt);
    AdminImpoundSelect.appendChild(optgroupNew);
    
    // Sélectionner le garage actuel par défaut, ou la première fourrière, ou le nouveau point
    if (CurrentOpenGarageId && ImpoundsList[CurrentOpenGarageId]) {
        AdminImpoundSelect.value = CurrentOpenGarageId;
    } else if (Object.keys(ImpoundsList).length > 0) {
        AdminImpoundSelect.value = Object.keys(ImpoundsList)[0];
    } else {
        AdminImpoundSelect.value = 'NEW_IMPOUND';
    }
    
    loadSelectedImpoundData();
}

// Charger les données de la fourrière sélectionnée dans les champs
function loadSelectedImpoundData() {
    const selectedId = AdminImpoundSelect.value;
    const adminTypeSelect = document.getElementById('admin-type-select');
    const deleteBtn = document.getElementById('admin-delete-btn');
    const deleteCoordsSection = document.getElementById('admin-delete-coords-section');
    
    if (selectedId === 'NEW_IMPOUND') {
        if (deleteBtn) deleteBtn.classList.add('hidden');
        AdminLabelInput.value = '';
        AdminPedSelect.value = 's_m_y_xmech_01';
        if (adminTypeSelect) adminTypeSelect.value = 'car';
        
        document.getElementById('coord-ped-x').value = '0.00';
        document.getElementById('coord-ped-y').value = '0.00';
        document.getElementById('coord-ped-z').value = '0.00';
        document.getElementById('coord-ped-h').value = '0.00';
        
        ActiveSpawnPoints = [{ x: 0.0, y: 0.0, z: 0.0, w: 0.0 }];

        document.getElementById('coord-delete-x').value = '0.00';
        document.getElementById('coord-delete-y').value = '0.00';
        document.getElementById('coord-delete-z').value = '0.00';
        document.getElementById('admin-delete-size').value = '7.0';
        document.getElementById('admin-blip-sprite').value = '357';
        document.getElementById('admin-blip-color').value = '3';
    } else {
        if (deleteBtn) deleteBtn.classList.remove('hidden');
        const imp = ImpoundsList[selectedId];
        AdminLabelInput.value = imp.label || '';
        AdminPedSelect.value = imp.pedModel || 's_m_y_xmech_01';
        if (adminTypeSelect) adminTypeSelect.value = imp.type || 'car';
        
        // Sécurité de lecture robuste pour éviter tout crash JS
        const coords = imp.coords || { x: 0.0, y: 0.0, z: 0.0 };
        const deleteCoords = imp.delete || { x: 0.0, y: 0.0, z: 0.0 };
        const pedHeading = imp.pedHeading !== undefined ? imp.pedHeading : 0.0;
        
        document.getElementById('coord-ped-x').value = (coords.x || 0.0).toFixed(2);
        document.getElementById('coord-ped-y').value = (coords.y || 0.0).toFixed(2);
        document.getElementById('coord-ped-z').value = (coords.z || 0.0).toFixed(2);
        document.getElementById('coord-ped-h').value = (pedHeading || 0.0).toFixed(2);
        
        if (imp.spawn) {
            if (Array.isArray(imp.spawn)) {
                ActiveSpawnPoints = JSON.parse(JSON.stringify(imp.spawn));
            } else {
                ActiveSpawnPoints = [JSON.parse(JSON.stringify(imp.spawn))];
            }
        } else {
            ActiveSpawnPoints = [{ x: 0.0, y: 0.0, z: 0.0, w: 0.0 }];
        }

        document.getElementById('coord-delete-x').value = (deleteCoords.x || 0.0).toFixed(2);
        document.getElementById('coord-delete-y').value = (deleteCoords.y || 0.0).toFixed(2);
        document.getElementById('coord-delete-z').value = (deleteCoords.z || 0.0).toFixed(2);
        document.getElementById('admin-delete-size').value = (imp.deleteSize !== undefined ? parseFloat(imp.deleteSize).toFixed(1) : '7.0');
        document.getElementById('admin-blip-sprite').value = (imp.blipSprite !== undefined ? imp.blipSprite : 357).toString();
        document.getElementById('admin-blip-color').value = (imp.blipColor !== undefined ? imp.blipColor : 3).toString();
    }

    renderSpawnPointsList();

    // Gérer la visibilité du point de rangement (masqué si fourrière)
    const pointType = adminTypeSelect ? adminTypeSelect.value : 'car';
    const sizeSection = document.getElementById('admin-delete-size-section');
    if (pointType === 'impound') {
        if (deleteCoordsSection) deleteCoordsSection.style.display = 'none';
        if (sizeSection) sizeSection.style.display = 'none';
    } else {
        if (deleteCoordsSection) deleteCoordsSection.style.display = 'block';
        if (sizeSection) sizeSection.style.display = 'block';
    }
}

// Gérer le changement de sélection de fourrière
AdminImpoundSelect.addEventListener('change', loadSelectedImpoundData);

// Sélection de position interactive sur place pour le PNJ
if (SelectPedBtn) {
    SelectPedBtn.addEventListener('click', function() {
        playSelectSound();
        fetch(`https://${GetParentResourceName()}/startPositionSelection`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ type: 'ped' })
        });
    });
}

// Sélection de position interactive sur place pour le Spawn de véhicule
if (SelectSpawnBtn) {
    SelectSpawnBtn.addEventListener('click', function() {
        playSelectSound();
        fetch(`https://${GetParentResourceName()}/startPositionSelection`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ type: 'spawn' })
        });
    });
}

// Sélection de position interactive sur place pour le Rangement de véhicule
if (SelectDeleteBtn) {
    SelectDeleteBtn.addEventListener('click', function() {
        playSelectSound();
        fetch(`https://${GetParentResourceName()}/startPositionSelection`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ type: 'delete' })
        });
    });
}

// Acquérir la position actuelle pour le PNJ
AcquirePedBtn.addEventListener('click', function() {
    playSelectSound();
    
    fetch(`https://${GetParentResourceName()}/getCurrentCoords`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    }).then(resp => resp.json())
      .then(coords => {
          document.getElementById('coord-ped-x').value = coords.x.toFixed(2);
          document.getElementById('coord-ped-y').value = coords.y.toFixed(2);
          document.getElementById('coord-ped-z').value = coords.z.toFixed(2);
          document.getElementById('coord-ped-h').value = coords.w.toFixed(2);
      });
});

// Générer dynamiquement la liste visuelle des points de sortie (Spawn)
function renderSpawnPointsList() {
    const listContainer = document.getElementById('admin-spawn-points-list');
    if (!listContainer) return;

    listContainer.innerHTML = '';

    if (ActiveSpawnPoints.length === 0) {
        listContainer.innerHTML = `<div style="text-align: center; color: var(--text-dark); padding: 10px 0; font-size: 10px;">Aucun point de sortie configuré. Cliquez sur AJOUTER.</div>`;
        return;
    }

    ActiveSpawnPoints.forEach((point, index) => {
        const card = document.createElement('div');
        card.className = 'spawn-point-card';
        card.style.background = 'rgba(255, 255, 255, 0.015)';
        card.style.border = '1px solid rgba(255, 255, 255, 0.03)';
        card.style.borderRadius = '10px';
        card.style.padding = '12px';
        card.style.display = 'flex';
        card.style.flexDirection = 'column';
        card.style.gap = '8px';

        card.innerHTML = `
            <div style="display: flex; justify-content: space-between; align-items: center; font-size: 9px; font-weight: 700; color: var(--text-white); letter-spacing: 0.5px;">
                <span><i class="fa-solid fa-location-dot" style="color: var(--primary); margin-right: 4px;"></i> SORTIE #${index + 1}</span>
                <div style="display: flex; gap: 6px; align-items: center;">
                    <button class="acquire-btn" onclick="acquirePointPos(${index})" style="padding: 3px 6px; font-size: 8.5px;" title="Prendre ma position actuelle instantanément"><i class="fa-solid fa-location-arrow"></i> MA POS</button>
                    <button class="acquire-btn" onclick="selectPointPos(${index})" style="padding: 3px 6px; font-size: 8.5px;" title="Choisir l'emplacement précis sur place"><i class="fa-solid fa-crosshairs"></i> SUR PLACE</button>
                    <button class="acquire-btn" onclick="deleteSpawnPoint(${index})" style="padding: 3px 6px; font-size: 8.5px; background: rgba(239, 68, 68, 0.1); border-color: rgba(239, 68, 68, 0.25); color: var(--primary);" title="Supprimer ce point de sortie"><i class="fa-solid fa-trash-can"></i></button>
                </div>
            </div>
            <div class="coords-inputs" style="grid-template-columns: repeat(4, 1fr); margin-top: 2px;">
                <div class="coord-val"><span>X:</span><input type="number" step="any" class="coord-input spawn-x" value="${(point.x || 0.0).toFixed(2)}" oninput="updateSpawnPointValue(${index}, 'x', this.value)"></div>
                <div class="coord-val"><span>Y:</span><input type="number" step="any" class="coord-input spawn-y" value="${(point.y || 0.0).toFixed(2)}" oninput="updateSpawnPointValue(${index}, 'y', this.value)"></div>
                <div class="coord-val"><span>Z:</span><input type="number" step="any" class="coord-input spawn-z" value="${(point.z || 0.0).toFixed(2)}" oninput="updateSpawnPointValue(${index}, 'z', this.value)"></div>
                <div class="coord-val"><span>H:</span><input type="number" step="any" class="coord-input spawn-h" value="${(point.w || 0.0).toFixed(2)}" oninput="updateSpawnPointValue(${index}, 'w', this.value)"></div>
            </div>
        `;
        listContainer.appendChild(card);
    });
}

// Mettre à jour les coordonnées éditées manuellement
window.updateSpawnPointValue = function(index, axis, val) {
    if (ActiveSpawnPoints[index]) {
        ActiveSpawnPoints[index][axis] = parseFloat(val) || 0.0;
    }
};

// Prendre la position du joueur pour une ligne précise
window.acquirePointPos = function(index) {
    playSelectSound();
    fetch(`https://${GetParentResourceName()}/getCurrentCoords`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    }).then(resp => resp.json())
      .then(coords => {
          if (ActiveSpawnPoints[index]) {
              ActiveSpawnPoints[index] = { x: coords.x, y: coords.y, z: coords.z, w: coords.w };
              renderSpawnPointsList();
          }
      });
};

// Mode sélection interactive sur place pour une ligne précise
window.selectPointPos = function(index) {
    playSelectSound();
    CurrentSelectingSpawnIndex = index;
    fetch(`https://${GetParentResourceName()}/startPositionSelection`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ type: 'spawn' })
    });
};

// Supprimer un point de spawn de la liste
window.deleteSpawnPoint = function(index) {
    playSelectSound();
    ActiveSpawnPoints.splice(index, 1);
    renderSpawnPointsList();
};

// Bouton d'ajout d'une nouvelle sortie
const AddSpawnBtn = document.getElementById('add-spawn-btn');
if (AddSpawnBtn) {
    AddSpawnBtn.addEventListener('click', function() {
        playSelectSound();
        ActiveSpawnPoints.push({ x: 0.0, y: 0.0, z: 0.0, w: 0.0 });
        renderSpawnPointsList();
        
        // Faire défiler automatiquement vers le bas de la liste
        const listContainer = document.getElementById('admin-spawn-points-list');
        if (listContainer) {
            setTimeout(() => {
                listContainer.scrollTop = listContainer.scrollHeight;
            }, 50);
        }
    });
}

// Acquérir la position actuelle pour le point de rangement
if (AcquireDeleteBtn) {
    AcquireDeleteBtn.addEventListener('click', function() {
        playSelectSound();
        
        fetch(`https://${GetParentResourceName()}/getCurrentCoords`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({})
        }).then(resp => resp.json())
          .then(coords => {
              document.getElementById('coord-delete-x').value = coords.x.toFixed(2);
              document.getElementById('coord-delete-y').value = coords.y.toFixed(2);
              document.getElementById('coord-delete-z').value = coords.z.toFixed(2);
          });
    });
}

// Gérer le changement dynamique de type pour masquer/afficher le point de rangement
const adminTypeSelect = document.getElementById('admin-type-select');
if (adminTypeSelect) {
    adminTypeSelect.addEventListener('change', function() {
        const deleteCoordsSection = document.getElementById('admin-delete-coords-section');
        const sizeSection = document.getElementById('admin-delete-size-section');
        const isAnyImpound = ['impound', 'impound_boat', 'impound_air', 'impound_helicopter'].includes(adminTypeSelect.value);
        if (isAnyImpound) {
            if (deleteCoordsSection) deleteCoordsSection.style.display = 'none';
            if (sizeSection) sizeSection.style.display = 'none';
        } else {
            if (deleteCoordsSection) deleteCoordsSection.style.display = 'block';
            if (sizeSection) sizeSection.style.display = 'block';
        }
    });
}

// Sauvegarder la configuration
AdminSaveBtn.addEventListener('click', function() {
    playSelectSound();
    
    let garageId = AdminImpoundSelect.value;
    const label = AdminLabelInput.value.trim();
    
    if (!label) {
        // Alerte simple si le nom est vide
        AdminLabelInput.focus();
        AdminLabelInput.style.borderColor = 'var(--primary)';
        setTimeout(() => { AdminLabelInput.style.borderColor = 'var(--border-main)'; }, 1500);
        return;
    }
    
    if (garageId === 'NEW_IMPOUND') {
        // Générer un ID unique sécurisé
        garageId = 'impound_custom_' + Date.now();
    }
    
    const pedX = parseFloat(document.getElementById('coord-ped-x').value) || 0.0;
    const pedY = parseFloat(document.getElementById('coord-ped-y').value) || 0.0;
    const pedZ = parseFloat(document.getElementById('coord-ped-z').value) || 0.0;
    const pedH = parseFloat(document.getElementById('coord-ped-h').value) || 0.0;
    
    const adminTypeSelect = document.getElementById('admin-type-select');
    const pointType = adminTypeSelect ? adminTypeSelect.value : 'car';
    
    const deleteX = parseFloat(document.getElementById('coord-delete-x').value) || 0.0;
    const deleteY = parseFloat(document.getElementById('coord-delete-y').value) || 0.0;
    const deleteZ = parseFloat(document.getElementById('coord-delete-z').value) || 0.0;

    // Lire tous les points de sortie de la liste ActiveSpawnPoints
    const spawnPoints = [];
    const cardRows = document.querySelectorAll('.spawn-point-card');
    cardRows.forEach(row => {
        const x = parseFloat(row.querySelector('.spawn-x').value) || 0.0;
        const y = parseFloat(row.querySelector('.spawn-y').value) || 0.0;
        const z = parseFloat(row.querySelector('.spawn-z').value) || 0.0;
        const h = parseFloat(row.querySelector('.spawn-h').value) || 0.0;
        spawnPoints.push({ x: x, y: y, z: z, w: h });
    });

    const config = {
        label: label,
        type: pointType,
        coords: { x: pedX, y: pedY, z: pedZ },
        pedHeading: pedH,
        pedModel: AdminPedSelect.value,
        blipSprite: parseInt(document.getElementById('admin-blip-sprite').value) || 357,
        blipColor: parseInt(document.getElementById('admin-blip-color').value) || 3,
        spawn: spawnPoints.length > 0 ? spawnPoints : [{ x: 0.0, y: 0.0, z: 0.0, w: 0.0 }],
        delete: { x: deleteX, y: deleteY, z: deleteZ },
        deleteSize: parseFloat(document.getElementById('admin-delete-size').value) || 7.0
    };
    
    // Envoyer au client pour sauvegarde persistante côté serveur
    fetch(`https://${GetParentResourceName()}/saveImpoundConfig`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            garageId: garageId,
            config: config
        })
    }).then(resp => resp.json())
      .then(data => {
          if (data.success) {
              AdminPanel.classList.remove('show');
              setTimeout(() => {
                  AdminPanel.classList.add('hidden');
              }, 400);
              closeGarage(); // Fermer le menu principal pour appliquer immédiatement
          }
      });
});

// Gérer la suppression administrative de point
const AdminDeleteBtn = document.getElementById('admin-delete-btn');
if (AdminDeleteBtn) {
    AdminDeleteBtn.addEventListener('click', function() {
        playSelectSound();
        const selectedId = AdminImpoundSelect.value;
        if (selectedId === 'NEW_IMPOUND') return;
        
        fetch(`https://${GetParentResourceName()}/deleteGarage`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ garageId: selectedId })
        }).then(resp => resp.json())
          .then(data => {
              if (data.success) {
                  AdminPanel.classList.remove('show');
                  setTimeout(() => {
                      AdminPanel.classList.add('hidden');
                  }, 400);
                  closeGarage(); // Fermer pour appliquer immédiatement
              }
          });
    });
}
