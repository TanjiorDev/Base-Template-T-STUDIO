// ============================================================
//  BLOODADMIN — HTML/JS/RENDERS.JS
// ============================================================

const PERM_LABELS = {
    'bl.ban': ['Bannissement', 'Révoquer définitivement l\'accès d\'un utilisateur au serveur'],
    'bl.kick': ['Expulsion', 'Déconnexion forcée immédiate d\'un utilisateur'],
    'bl.warn': ['Avertissements', 'Attribuer des avertissements officiels enregistrés en base de données'],
    'bl.spectate': ['Surveillance', 'Observer les faits et gestes d\'un utilisateur en toute discrétion'],
    'bl.freeze': ['Immobilisation', 'Geler les mouvements d\'un utilisateur pour intervention'],
    'bl.staff': ['Gestion Staff', 'Contrôler la hiérarchie et les droits d\'accès de l\'équipe'],
    'bl.resources': ['Développement', 'Gérer l\'état des scripts et ressources système (Start/Stop/Restart)'],
    'bl.logs': ['Audits & Logs', 'Consulter l\'historique complet des actions administratives'],
    'bl.anticheat': ['Sécurité', 'Surveiller les alertes de triche et les comportements suspects'],
    'bl.money': ['Trésorerie', 'Gestion des flux monétaires (Cash, Banque, Argent sale)'],
    'bl.item': ['Logistique', 'Générer et distribuer des objets issus de la base de données'],
    'bl.job': ['Carrières', 'Modifier l\'affectation professionnelle et le rang des citoyens'],
    'bl.noclip': ['Translation', 'Mode de déplacement libre à travers l\'environnement'],
    'bl.teleport': ['Navigation', 'Déplacements instantanés (Goto, Bring, Coordonnées)'],
    'bl.revive': ['Assistance Médicale', 'Réanimer instantanément un citoyen inconscient'],
    'bl.heal': ['Restauration', 'Soigner les blessures et combler les besoins vitaux'],
    'bl.inventory': ['Fouille', 'Inspecter et manipuler le contenu des inventaires'],
    'bl.delveh': ['Nettoyage', 'Supprimer les véhicules et entités du monde'],
    'bl.spawnveh': ['Concession', 'Matérialiser des véhicules spécifiques sur demande'],
    'bl.giveveh': ['Don de Véhicule', 'Attribuer définitivement la propriété d\'un véhicule à un joueur'],
    'bl.repairveh': ['Maintenance Véhicule', 'Réparer, nettoyer, retourner ou refuel un véhicule'],
    'bl.customveh': ['Custom Véhicule', 'Modifier la peinture, la plaque, godmode ou boost véhicule'],
    'bl.customcatalog': ['Catalogue Custom', 'Sauvegarder des véhicules personnalisés dans le catalogue'],
    'bl.tpzones': ['TP Zones', 'Téléporter les joueurs vers des zones prédéfinies'],
    'bl.esp': ['Vue Tactique', 'Afficher les informations des joueurs à travers les obstacles'],
    'bl.blips': ['Traçage Map', 'Afficher tous les joueurs sur la carte (Blips)'],
    'bl.jail': ['Emprisonnement', 'Envoyer un individu purger une peine en prison'],
    'bl.ghost': ['Ghost Ban', 'Isoler un individu dans une dimension fantôme (Routing Bucket)'],
    'bl.world': ['Monde & Climat', 'Contrôler la météo, le temps, figer le climat et gérer le blackout/vsync'],
    'bl.offlinemod': ['Modération Hors-ligne', 'Bannir, avertir, promouvoir ou lister les comptes hors-ligne de la base de données'],
    'bl.viewip': ['Voir les IP', 'Visualiser l\'adresse IP des joueurs connectés (confidentialité critique)']
};

function renderPlayers() {
    const list = $('player-list'); if(!list) return;
    const search = ($('player-search')?.value || '').toLowerCase();
    list.innerHTML = '';
    
    // Mise à jour du badge dans la sidebar
    if($('player-count')) $('player-count').textContent = state.players.length;
    
    // Mise à jour des cartes métriques du cockpit joueur
    if ($('pm-total-online')) $('pm-total-online').textContent = state.players.length;
    if ($('pm-active-staff')) {
        const staffOnline = state.players.filter(p => p.grade && p.grade !== '' && p.grade !== 'user').length;
        $('pm-active-staff').textContent = staffOnline;
    }
    if ($('pm-avg-ping')) {
        const avg = state.players.length > 0 ? Math.round(state.players.reduce((a, b) => a + (b.ping || 0), 0) / state.players.length) : 0;
        $('pm-avg-ping').textContent = avg > 0 ? avg + ' ms' : '-- ms';
    }
    if ($('pm-registered-offline')) $('pm-registered-offline').textContent = state.offlinePlayers ? state.offlinePlayers.length : 0;
    
    const isOfflineMode = state.playersFilter === 'offline';
    const listSource = isOfflineMode ? state.offlinePlayers : state.players;
    
    const filtered = listSource.filter(p => {
        const nameMatch = p.name.toLowerCase().includes(search);
        const idMatch = isOfflineMode ? p.identifier.toLowerCase().includes(search) : p.id.toString().includes(search);
        const jobMatch = p.job ? p.job.toLowerCase().includes(search) : false;
        return nameMatch || idMatch || jobMatch;
    });

    if (filtered.length === 0) {
        list.innerHTML = `<div class="empty-state">${isOfflineMode ? 'Aucun joueur hors-ligne trouvé' : 'Aucun joueur connecté'}</div>`;
        return;
    }
    
    filtered.forEach(p => {
        const div = document.createElement('div');
        
        let isSelected = false;
        if (state.selectedPlayer) {
            if (isOfflineMode && state.selectedPlayer.isOffline && state.selectedPlayer.identifier === p.identifier) {
                isSelected = true;
            } else if (!isOfflineMode && !state.selectedPlayer.isOffline && state.selectedPlayer.id === p.id) {
                isSelected = true;
            }
        }
        
        div.className = `player-card-v4 ${isSelected ? 'selected' : ''}`;
        
        let gradeBadge = '';
        if (p.grade && p.grade !== '' && p.grade !== 'user') {
            const gData = (state.config?.Permissions || {})[p.grade] || {};
            const color = gData._color || 'var(--muted)';
            const icon  = gData._icon || '🛡️';
            gradeBadge = `<span class="grade-badge" style="color:${color}; border-color:${color}33">
                <span style="font-size:12px; margin-right:4px">${icon}</span>
                ${p.grade}
            </span>`;
        }

        const initials = p.name ? p.name.split(' ').map(n => n[0]).join('').substring(0, 2).toUpperCase() : '?';

        if (isOfflineMode) {
            let jobBadge = '';
            if (p.job && p.job !== 'unemployed') {
                jobBadge = `<span class="grade-badge" style="color:var(--cyan); border-color:var(--cyan)33">
                    💼 ${p.job}
                </span>`;
            }
            div.innerHTML = `
                <div class="pc-avatar offline">
                    ${initials}
                    <div class="pc-status-dot offline"></div>
                </div>
                <div class="pc-details">
                    <div class="pc-header-row">
                        <span class="pc-name">${esc(p.name)}</span>
                        <span class="pc-id-badge offline">OFFLINE</span>
                    </div>
                    <div class="pc-badges-row">
                        ${gradeBadge}
                        ${jobBadge}
                    </div>
                </div>
                <div class="pc-ping-sec">
                    <span class="pc-ping-text offline">Hors-ligne</span>
                </div>
            `;
            div.onclick = () => {
                const offlinePlayer = { ...p, isOffline: true, id: 'OFFLINE' };
                selectPlayer(offlinePlayer);
            };
        } else {
            let jobBadge = '';
            if (p.job && p.job !== 'unemployed') {
                jobBadge = `<span class="grade-badge" style="color:var(--cyan); border-color:var(--cyan)33">
                    💼 ${p.job}
                </span>`;
            }
            const pingClass = getPingClass(p.ping);
            div.innerHTML = `
                <div class="pc-avatar online">
                    ${initials}
                    <div class="pc-status-dot online"></div>
                </div>
                <div class="pc-details">
                    <div class="pc-header-row">
                        <span class="pc-name">${esc(p.name)}</span>
                        <span class="pc-id-badge online">ID #${p.id}</span>
                    </div>
                    <div class="pc-badges-row">
                        ${gradeBadge}
                        ${jobBadge}
                    </div>
                </div>
                <div class="pc-ping-sec">
                    <span class="pc-ping-text ${pingClass}">${p.ping}ms</span>
                    <div class="pc-ping-icon ${pingClass}">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><path d="M5 12.5a3 3 0 0 1 3-3h8a3 3 0 0 1 3 3M8 9.5a6 6 0 0 1 6-6h4"/></svg>
                    </div>
                </div>
            `;
            div.onclick = () => selectPlayer(p);
        }
        
        list.appendChild(div);
    });
}

function renderDashActivity() {
    const list = $('dash-activity-list'); if(!list) return;
    list.innerHTML = '';
    
    if (!state.logs || state.logs.length === 0) {
        $('dash-activity-empty').classList.remove('hidden');
        return;
    }
    $('dash-activity-empty').classList.add('hidden');

    // Take last 8 logs
    const recent = [...state.logs].reverse().slice(0, 8);
    recent.forEach(l => {
        const div = document.createElement('div');
        let catClass = '';
        if (l.category === 'moderation') catClass = 'mod';
        if (l.category === 'economy') catClass = 'econ';
        if (l.category === 'staff') catClass = 'staff';

        const date = new Date(l.timestamp).toLocaleTimeString('fr-FR', { hour: '2-digit', minute: '2-digit' });
        
        div.className = `activity-item ${catClass}`;
        div.innerHTML = `
            <div class="ai-icon">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
            </div>
            <div class="ai-content">
                <div class="ai-title">${esc(l.action)}</div>
                <div class="ai-desc"><span>${esc(l.admin_name)}</span> ${l.target_name ? `sur <span>${esc(l.target_name)}</span>` : ''}</div>
                <div class="ai-time">${date}</div>
            </div>
        `;
        list.appendChild(div);
    });
}

function renderStaff() {
    const list = $('staff-list'); if(!list) return;
    list.innerHTML = '';
    state.staff.forEach(s => {
        const perms = state.config?.Permissions || {};
        const gData = perms[s.grade] || {};
        const color = gData._color || 'var(--muted)';
        const icon  = gData._icon  || '🛡️';

        const div = document.createElement('div');
        div.className = 'staff-card';
        div.innerHTML = `
            <div class="sc-avatar" style="background:${color}15; color:${color}; border: 1px solid ${color}33">${esc(s.name[0])}</div>
            <div class="sc-info">
                <div class="sc-name">${esc(s.name)}</div>
                <div class="grade-badge" style="color:${color}; border-color:${color}33; font-size:8px; padding:2px 6px">
                    <span style="margin-right:4px">${icon}</span>
                    ${esc(s.grade.toUpperCase())}
                </div>
            </div>
            <div class="sc-id">#${s.id}</div>
        `;
        list.appendChild(div);
    });
}

function renderResources() {
    const tbody = $('res-tbody'); if(!tbody) return;
    const search = ($('resource-search')?.value || '').toLowerCase();
    tbody.innerHTML = '';
    const filtered = (state.allResources || []).filter(r => r.name.toLowerCase().includes(search));
    filtered.forEach(r => {
        const isStarted = r.status === 'started';
        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td><div class="res-name-cell"><span class="res-icon ${isStarted?'online':''}"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="16 18 22 12 16 6"/><polyline points="8 6 2 12 8 18"/></svg></span><span class="res-name-text">${esc(r.name)}</span></div></td>
            <td><span class="status-badge ${isStarted?'status-online':'status-offline'}">${r.status}</span></td>
            <td><span class="mono muted">${esc(r.version)}</span></td>
            <td><span class="muted">${esc(r.author)}</span></td>
            <td>
                <div class="actions-cell">
                    <button class="res-act-btn" title="Copier Nom" onclick="handleResourceAction('${esc(r.name)}', 'copy')">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="9" y="9" width="13" height="13" rx="2" ry="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg>
                    </button>
                    <button class="res-act-btn restart" title="Restart" onclick="handleResourceAction('${esc(r.name)}', 'restart')">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="23 4 23 10 17 10"/><polyline points="1 20 1 14 7 14"/><path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"/></svg>
                    </button>
                    <button class="res-act-btn ${isStarted ? 'stop' : 'start'}" title="${isStarted ? 'Stop' : 'Start'}" onclick="handleResourceAction('${esc(r.name)}', '${isStarted ? 'stop' : 'start'}')">
                        ${isStarted ? '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="6" y="6" width="12" height="12"/></svg>' : '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="5 3 19 12 5 21 5 3"/></svg>'}
                    </button>
                </div>
            </td>
        `;
        tbody.appendChild(tr);
    });
}

function renderPermissions() {
    const list = $('perms-grades-list'); if(!list) return;
    list.innerHTML = '';
    
    // Sort grades by level (descending)
    const grades = Object.keys(state.config.Permissions || {}).sort((a, b) => {
        return (state.config.Permissions[b].level || 0) - (state.config.Permissions[a].level || 0);
    });

    grades.forEach(g => {
        const div = document.createElement('div');
        const isActive = state.selectedGrade === g;
        const config = state.config.Permissions[g];
        
        // Dynamic color based on level
        let color = '#94a3b8'; // Default
        if (config.level >= 100) color = '#f87171'; // Owner/Boss (Red)
        else if (config.level >= 90) color = '#fbbf24'; // Superviseur (Amber)
        else if (config.level >= 80) color = '#60a5fa'; // Superadmin (Blue)
        else if (config.level >= 70) color = '#34d399'; // Admin (Green)
        else if (config.level >= 50) color = '#818cf8'; // Mod (Indigo)

        const displayName = g.charAt(0).toUpperCase() + g.slice(1);
        const myLevel = state.config.Permissions[state.myGrade]?.level || 0;
        const isLocked = myLevel <= config.level && myLevel < 100;

        div.className = `pg-item ${isActive ? 'active' : ''} ${isLocked ? 'locked' : ''}`;
        div.style.borderLeft = isActive ? `3px solid ${color}` : `1px solid transparent`;
        
        div.innerHTML = `
            <div class="pg-info">
                <div style="display:flex; align-items:center; gap:5px">
                    <span class="pg-name" style="color: ${isActive ? color : '#fff'}">${displayName}</span>
                    ${isLocked ? '<svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" style="opacity:0.5"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>' : ''}
                </div>
                <span class="pg-level-tag" style="background: ${color}20; color: ${color}">LVL ${config.level}</span>
            </div>
            <div class="pg-indicator" style="background: ${color}"></div>
        `;
        div.onclick = () => selectGrade(g);
        list.appendChild(div);
    });

    if (state.selectedGrade) renderPermissionTogglesV2();
}

function renderPermissionTogglesV2() {
    console.log('[BloodAdmin] Rendering Permission Toggles for:', state.selectedGrade);
    const grid = $('perms-toggles-grid'); if(!grid) return;
    const search = ($('perm-search')?.value || '').toLowerCase();
    grid.innerHTML = '';
    
    const grade = state.selectedGrade;
    const perms = state.config.Permissions[grade];
    if (!perms) {
        grid.innerHTML = '<div class="muted" style="padding:20px">Aucune permission configurée pour ce grade.</div>';
        return;
    }

    // Hierarchy Check
    const myGrade = state.myGrade;
    const myLevel = state.config.Permissions[myGrade]?.level || 0;
    const targetLevel = perms.level || 0;
    const canEdit = myLevel > targetLevel || myLevel >= 100; // Boss can edit everything (or just check level)

    if (!canEdit) {
        $('perm-sub-title').innerHTML = `<span style="color:var(--red2)">Lecture seule</span> — Hiérarchie insuffisante pour modifier ce grade.`;
    } else {
        $('perm-sub-title').textContent = `Configurez les droits d'accès en temps réel`;
    }

    const categories = {
        'Modération': ['bl.ban', 'bl.kick', 'bl.warn', 'bl.spectate', 'bl.freeze', 'bl.jail', 'bl.ghost', 'bl.offlinemod'],
        'Administration': ['bl.staff', 'bl.resources', 'bl.logs', 'bl.anticheat', 'bl.esp', 'bl.viewip'],
        'Économie': ['bl.money', 'bl.item', 'bl.job'],
        'Véhicules': ['bl.spawnveh', 'bl.delveh', 'bl.repairveh', 'bl.customveh', 'bl.giveveh', 'bl.customcatalog'],
        'Outils & Monde': ['bl.noclip', 'bl.teleport', 'bl.revive', 'bl.heal', 'bl.inventory', 'bl.tpzones', 'bl.blips']
    };

    let totalRendered = 0;
    Object.keys(categories).forEach(cat => {
        const filteredPerms = categories[cat].filter(p => p.toLowerCase().includes(search));
        if (filteredPerms.length === 0) return;

        const card = document.createElement('div');
        card.className = 'perm-cat-card';
        card.innerHTML = `<div class="pcc-title">${cat}</div><div class="pcc-grid"></div>`;
        const pccGrid = card.querySelector('.pcc-grid');

        filteredPerms.forEach(p => {
            const has = perms[p] === true;
            const [label, desc] = PERM_LABELS[p] || [p, 'Permission système'];
            
            const toggle = document.createElement('div');
            toggle.className = `perm-toggle-row-v2 detailed ${!canEdit ? 'disabled' : ''}`;
            toggle.innerHTML = `
                <div class="ptr-info">
                    <div class="ptr-label">${label}</div>
                    <div class="ptr-desc">${desc}</div>
                    <div class="ptr-key">${p}</div>
                </div>
                <label class="switch small">
                    <input type="checkbox" ${has ? 'checked' : ''} ${!canEdit ? 'disabled' : ''} onchange="toggleGradePerm('${grade}', '${p}', this.checked)"/>
                    <span class="switch-track"><span class="switch-thumb"></span></span>
                </label>
            `;
            pccGrid.appendChild(toggle);
            totalRendered++;
        });
        grid.appendChild(card);
    });

    if (totalRendered === 0 && search !== '') {
        grid.innerHTML = `<div class="muted" style="padding:20px">Aucun résultat pour "${search}"</div>`;
    }
}

function renderStaffMembers() {
    const tbody = $('staff-members-tbody'); if(!tbody) return;
    const search = ($('staff-member-search')?.value || '').toLowerCase();
    tbody.innerHTML = '';
    const filtered = (state.allStaff || []).filter(s => s.name.toLowerCase().includes(search) || s.identifier.toLowerCase().includes(search));
    filtered.forEach(s => {
        const tr = document.createElement('tr');
        const statusClass = s.online ? 'status-online' : 'status-offline';
        const statusLabel = s.online ? 'En ligne' : 'Hors-ligne';
        
        const gData = state.config.Permissions[s.grade] || {};
        const gColor = gData._color || 'var(--muted)';
        const gIcon  = gData._icon || '🛡️';
        
        const myLevel = state.config.Permissions[state.myGrade]?.level || 0;
        const targetLevel = gData.level || 0;
        const canManage = myLevel > targetLevel || myLevel >= 100;

        tr.innerHTML = `
            <td><div class="dt-player"><div class="dt-avatar" style="background:${gColor}15; color:${gColor}">${esc(s.name[0])}</div><span class="dt-name">${esc(s.name)}</span></div></td>
            <td class="mono muted" style="font-size:10px">${esc(s.identifier)}</td>
            <td>
                <div class="grade-badge" style="color:${gColor}; border-color:${gColor}33; font-size:9px; padding:3px 8px">
                    <span style="margin-right:5px">${gIcon}</span>
                    ${esc(s.grade.toUpperCase())}
                </div>
            </td>
            <td><span class="status-badge ${statusClass}">${statusLabel}</span></td>
            <td>
                <div class="actions-cell">
                    ${canManage ? `
                        <button class="res-act-btn" title="Changer" onclick="changeStaffGrade('${esc(s.identifier)}', '${esc(s.grade)}')">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="8.5" cy="7" r="4"/><polyline points="17 11 19 13 23 9"/></svg>
                        </button>
                        <button class="res-act-btn stop" title="Destituer" onclick="removeStaff('${esc(s.identifier)}', '${esc(s.name)}')">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18.36 6.64a9 9 0 1 1-12.73 0"/><line x1="12" y1="2" x2="12" y2="12"/></svg>
                        </button>
                    ` : '<span class="muted" style="font-size:10px; font-style:italic">Non gérable</span>'}
                </div>
            </td>
        `;
        tbody.appendChild(tr);
    });
}
function updateSanctionStats() {
    const bans = state.bans || [];
    const warns = state.warns || [];
    const jails = state.jails || {};
    const ghosts = state.ghosts || {};

    const jailsArr = Object.keys(jails);
    const ghostsArr = Object.keys(ghosts);
    
    if ($('st-active-bans')) $('st-active-bans').innerText = bans.length;
    if ($('st-total-warns')) $('st-total-warns').innerText = warns.length;
    
    if ($('badge-bans')) $('badge-bans').innerText = bans.length;
    if ($('badge-warns')) $('badge-warns').innerText = warns.length;
    if ($('badge-jails')) $('badge-jails').innerText = jailsArr.length;
    if ($('badge-ghosts')) $('badge-ghosts').innerText = ghostsArr.length;

    // Update the sidebar tab badge
    const totalSanctions = bans.length + warns.length + jailsArr.length + ghostsArr.length;
    if ($('ban-count')) {
        $('ban-count').innerText = totalSanctions;
        if (totalSanctions > 0) {
            $('ban-count').classList.remove('hidden');
        } else {
            $('ban-count').classList.add('hidden');
        }
    }


    const recent = (state.logs || []).filter(l => {
        const time = new Date(l.timestamp).getTime();
        const yesterday = Date.now() - (24 * 3600 * 1000);
        return time > yesterday && l.category === 'moderation';
    }).length;
    if ($('st-recent-actions')) $('st-recent-actions').innerText = recent;
}

function renderBans() {
    const tbody = $('ban-list-tbody'); if(!tbody) return;
    const search = ($('sanction-search')?.value || '').toLowerCase();
    tbody.innerHTML = '';
    
    const filtered = (state.bans || []).filter(b => 
        b.name.toLowerCase().includes(search) || 
        b.reason.toLowerCase().includes(search) ||
        b.admin.toLowerCase().includes(search)
    );
    
    updateSanctionStats();

    if (filtered.length === 0) {
        $('empty-bans').classList.remove('hidden');
        return;
    }
    $('empty-bans').classList.add('hidden');
    
    filtered.forEach(b => {
        const expires = b.expires === 0 ? '<span class="s-badge perm">Permanent</span>' : `<span class="s-badge temp">${new Date(b.expires * 1000).toLocaleString('fr-FR', {day:'2-digit', month:'2-digit', hour:'2-digit', minute:'2-digit'})}</span>`;
        const tr = document.createElement('tr');
        tr.className = 'sanction-row-v4';
        tr.innerHTML = `
            <td>
                <div class="dt-player-info">
                    <div class="dt-name">${esc(b.name)}</div>
                    <div class="dt-id">#${b.id}</div>
                </div>
            </td>
            <td><div class="s-reason" title="${esc(b.reason)}">${esc(b.reason)}</div></td>
            <td><span class="dt-name" style="font-size:11px">${esc(b.admin)}</span></td>
            <td>${expires}</td>
            <td style="text-align:right">
                <div class="s-actions">
                    <button class="s-btn revoke" onclick="if(checkDuty()) sendToClient('unbanPlayer', ${b.id})">Débannir</button>
                </div>
            </td>
        `;
        tbody.appendChild(tr);
    });
}

function renderWarns() {
    const tbody = $('warn-list-tbody'); if(!tbody) return;
    const search = ($('sanction-search')?.value || '').toLowerCase();
    tbody.innerHTML = '';
    
    const filtered = (state.warns || []).filter(w => 
        w.name.toLowerCase().includes(search) || 
        w.reason.toLowerCase().includes(search) ||
        w.admin.toLowerCase().includes(search)
    );
    
    if (filtered.length === 0) {
        $('empty-warns').classList.remove('hidden');
        return;
    }
    $('empty-warns').classList.add('hidden');
    
    filtered.forEach(w => {
        const date = new Date(w.timestamp).toLocaleString('fr-FR', {day:'2-digit', month:'2-digit', hour:'2-digit', minute:'2-digit'});
        const tr = document.createElement('tr');
        tr.className = 'sanction-row-v4';
        tr.innerHTML = `
            <td>
                <div class="dt-player-info">
                    <div class="dt-name">${esc(w.name)}</div>
                    <div class="dt-id">#${w.id}</div>
                </div>
            </td>
            <td><div class="s-reason" title="${esc(w.reason)}">${esc(w.reason)}</div></td>
            <td><span class="dt-name" style="font-size:11px">${esc(w.admin)}</span></td>
            <td><span class="s-date">${date}</span></td>
            <td style="text-align:right">
                <div class="s-actions">
                    <button class="s-btn revoke" onclick="if(checkDuty()) sendToClient('revokeWarn', ${w.warn_id || w.id})">Révoquer</button>
                </div>
            </td>
        `;
        tbody.appendChild(tr);
    });
}

function renderJails() {
    const tbody = $('jail-list-tbody'); if(!tbody) return;
    tbody.innerHTML = '';
    const jails = state.jails || {};
    const ids = Object.keys(jails);

    if (ids.length === 0) {
        $('empty-jails').classList.remove('hidden');
        return;
    }
    $('empty-jails').classList.add('hidden');

    ids.forEach(id => {
        const j = jails[id];
        if (!j) return;
        const expires = new Date(j.expires * 1000).toLocaleTimeString('fr-FR', { hour: '2-digit', minute: '2-digit' });
        const tr = document.createElement('tr');
        tr.className = 'sanction-row-v4';
        tr.innerHTML = `
            <td><span class="dt-name">${esc(j.name)}</span> <span class="muted">#${id}</span></td>
            <td><span class="dt-name" style="font-size:11px">${esc(j.admin)}</span></td>
            <td><span class="s-badge temp">${expires}</span></td>
            <td style="text-align:right">
                <div class="s-actions">
                    <button class="s-btn revoke" onclick="sendToClient('unjailPlayer', '${id}')">Libérer</button>
                </div>
            </td>
        `;
        tbody.appendChild(tr);
    });
}

function renderGhosts() {
    const tbody = $('ghost-list-tbody'); if(!tbody) return;
    tbody.innerHTML = '';
    const ghosts = state.ghosts || {};
    const ids = Object.keys(ghosts);

    if (ids.length === 0) {
        $('empty-ghosts').classList.remove('hidden');
        return;
    }
    $('empty-ghosts').classList.add('hidden');

    ids.forEach(id => {
        const g = ghosts[id];
        if (!g) return;
        const date = new Date(g.time * 1000).toLocaleTimeString('fr-FR', { hour: '2-digit', minute: '2-digit' });
        const tr = document.createElement('tr');
        tr.className = 'sanction-row-v4';
        tr.innerHTML = `
            <td><span class="dt-name">${esc(g.name)}</span> <span class="muted">#${id}</span></td>
            <td><span class="dt-name" style="font-size:11px">${esc(g.admin)}</span></td>
            <td><span class="s-date">${date}</span></td>
            <td style="text-align:right">
                <div class="s-actions">
                    <button class="s-btn revoke" onclick="sendToClient('unghostPlayer', '${id}')">Rétablir</button>
                </div>
            </td>
        `;
        tbody.appendChild(tr);
    });
}

function renderLogs() {
    const tbody = $('logs-tbody'); if(!tbody) return;
    const search = ($('log-search')?.value || '').toLowerCase();
    tbody.innerHTML = '';

    const filtered = (state.logs || []).filter(l => 
        l.admin_name.toLowerCase().includes(search) || 
        (l.target_name || '').toLowerCase().includes(search) || 
        l.action.toLowerCase().includes(search) ||
        (l.details || '').toLowerCase().includes(search)
    );

    if (filtered.length === 0) {
        $('logs-empty').classList.remove('hidden');
        return;
    }
    $('logs-empty').classList.add('hidden');

    filtered.forEach(l => {
        const tr = document.createElement('tr');
        const date = new Date(l.timestamp).toLocaleString('fr-FR', { day: '2-digit', month: '2-digit', hour: '2-digit', minute: '2-digit' });
        
        let catClass = 'neutral';
        if (l.category === 'moderation') catClass = 'status-offline';
        if (l.category === 'economy') catClass = 'status-online';
        if (l.category === 'staff') catClass = 'status-amber';
        if (l.category === 'world') catClass = 'status-blue';
        if (l.category === 'resources') catClass = 'status-purple';
        if (l.category === 'vehicle') catClass = 'status-vehicle';

        const detailsClean = (l.details || '').replace(/"/g, '&quot;');
        const logString = `[${date}] [${l.category.toUpperCase()}] ${l.action} - Admin: ${l.admin_name} - Cible: ${l.target_name || 'N/A'} - Détails: ${l.details || ''}`;

        tr.innerHTML = `
            <td class="mono muted" style="font-size:11px">${date}</td>
            <td><span class="status-badge ${catClass}" style="text-transform:uppercase;font-size:9px">${l.category}</span></td>
            <td><span class="bold" style="color:var(--text);font-size:11px">${l.action}</span></td>
            <td><span class="dt-name">${esc(l.admin_name)}</span> <span class="muted" style="font-size:9px">(#${l.admin_id})</span></td>
            <td>${l.target_name && l.target_name !== '?' ? `<span class="dt-name">${esc(l.target_name)}</span> <span class="muted" style="font-size:9px">(#${l.target_id})</span>` : '<span class="muted">—</span>'}</td>
            <td><div class="log-details-text" title="${esc(l.details || '')}">${esc(l.details || '')}</div></td>
            <td style="text-align:right">
                <button class="sm-action-btn-mini" style="padding:4px 8px; font-size:10px" onclick="copyLog(\`${logString.replace(/`/g, '\\`').replace(/\$/g, '\\$')}\`)">
                    Copier
                </button>
            </td>
        `;
        tbody.appendChild(tr);
    });
}

window.copyLog = (text) => {
    const el = document.createElement('textarea');
    el.value = text;
    document.body.appendChild(el);
    el.select();
    document.execCommand('copy');
    document.body.removeChild(el);
    showToast('Log copié dans le presse-papier !', 'success');
};

function renderStaffChat() {
    const list = $('staff-chat-messages'); if(!list) return;
    list.innerHTML = '';
    
    // Filter for global channel
    const msgs = (state.staffChat || []).filter(m => !m.channel || m.channel === 'global');

    if (msgs.length === 0) {
        list.innerHTML = '<div class="chat-empty">Aucun message récent</div>';
        return;
    }

    msgs.forEach((m, idx) => {
        const div = document.createElement('div');
        const isMe = m.sender_id == state.myId;
        div.className = `chat-msg ${isMe ? 'me' : ''}`;
        
        const time = m.timestamp ? new Date(m.timestamp * 1000).toLocaleTimeString('fr-FR', { hour: '2-digit', minute: '2-digit' }) : '';
        
        // Mentions highlight
        let processedMsg = esc(m.message);
        processedMsg = processedMsg.replace(/@everyone/g, '<span class="mention everyone">@everyone</span>');
        processedMsg = processedMsg.replace(/@(\w+)/g, '<span class="mention">@$1</span>');

        // Reply preview
        let replyHtml = '';
        if (m.reply_to && m.reply_to.message) {
            replyHtml = `
                <div class="msg-reply-link">
                    <span class="mrl-name">${esc(m.reply_to.name || 'Staff')}</span>
                    <span class="mrl-text">${esc(m.reply_to.message)}</span>
                </div>
            `;
        }

        div.innerHTML = `
            <div class="cm-header">
                <span class="cm-label">${esc(m.grade)}</span>
                <span class="cm-name">${esc(m.sender_name)}</span>
                <span class="cm-time">${time}</span>
                <button class="cm-reply-btn" onclick="replyToMessage(${idx})">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M9 14L4 9l5-5"/><path d="M20 20v-7a4 4 0 00-4-4H4"/></svg>
                </button>
            </div>
            <div class="cm-bubble">
                ${replyHtml}
                ${processedMsg}
            </div>
        `;
        list.appendChild(div);
    });
    
    setTimeout(() => {
        list.scrollTop = list.scrollHeight;
    }, 50);
}

// ── STAFF MODE V4 RENDERS ───────────────────────────────────────

function renderSMReportsV4() {
    const list = $('sm-report-list-v4'); if(!list) return;
    list.innerHTML = '';
    
    const reports = state.reports || [];
    
    // Update counters
    if ($('rep-open-count')) $('rep-open-count').textContent = reports.length;
    if ($('rep-total-count')) $('rep-total-count').textContent = state.totalReports || 0;
    if ($('rep-closed-count')) $('rep-closed-count').textContent = (state.totalReports || 0) - reports.length;
    if ($('dc-reports-active')) $('dc-reports-active').textContent = reports.length;
    
    // Sidebar badge
    const badge = $('report-count');
    if (badge) {
        badge.textContent = reports.length;
        if (reports.length > 0) badge.classList.remove('hidden');
        else badge.classList.add('hidden');
    }

    if (reports.length === 0) {
        list.innerHTML = '<div class="empty-state">Aucun report actif pour le moment.</div>';
        return;
    }

    reports.forEach(r => {
        const div = document.createElement('div');
        div.className = `report-card-v4 ${r.claimedBy ? 'claimed' : ''}`;
        
        // Safety check for timestamp
        let date = '—';
        try {
            if (r.timestamp) {
                date = new Date(r.timestamp).toLocaleTimeString('fr-FR', { hour: '2-digit', minute: '2-digit' });
            }
        } catch(e) {}
        
        const pName = r.playerName || 'Joueur Inconnu';
        const pId = r.playerId || 'OFF';
        const claimInfo = r.claimedBy ? `<div class="rcv4-claimed-by">Pris par: <span>${esc(r.claimedBy)}</span></div>` : '';
        const claimBtn = !r.claimedBy ? `<button class="rcv4-btn amber-btn" onclick="handleReportAction(${r.id}, 'claim')">PRENDRE</button>` : '';

        div.innerHTML = `
            <div class="rcv4-header">
                <div class="rcv4-user">
                    <div class="rcv4-avatar">${esc(pName[0]?.toUpperCase() || '?')}</div>
                    <div class="rcv4-info">
                        <span class="rcv4-name">${esc(pName)}</span>
                        <span class="rcv4-id">ID: ${pId} · Ticket #${r.id}</span>
                    </div>
                </div>
                <div class="rcv4-time">${date}</div>
            </div>
            <div class="rcv4-reason">${esc(r.reason || 'Aucune raison')}</div>
            <div class="rcv4-location" style="font-size: 10px; color: var(--muted); margin-bottom: 8px; display: flex; align-items: center; gap: 4px;">
                <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
                ${r.coords ? `${Math.round(r.coords.x)}, ${Math.round(r.coords.y)}, ${Math.round(r.coords.z)}` : 'Position inconnue'}
            </div>
            ${claimInfo}
            <div class="rcv4-actions">
                ${claimBtn}
                <button class="rcv4-btn primary" onclick="handleReportAction(${r.id}, 'goto')" ${!r.playerId ? 'disabled' : ''}>GOTO</button>
                <button class="rcv4-btn" onclick="handleReportAction(${r.id}, 'bring')" ${!r.playerId ? 'disabled' : ''}>BRING</button>
                <button class="rcv4-btn close-report" onclick="handleReportAction(${r.id}, 'close')">TERMINER</button>
            </div>
        `;
        list.appendChild(div);
    });
}

function renderReports() {
    console.log('[bl_admin] Rendering reports main tab. Count:', state.reports?.length);
    const grid = $('reports-grid'); if(!grid) return;
    const empty = $('reports-empty');
    const search = ($('report-search')?.value || '').toLowerCase();
    grid.innerHTML = '';

    if (!state.reports) state.reports = [];

    const filtered = state.reports.filter(r => 
        (r.playerName || '').toLowerCase().includes(search) || 
        (r.license || '').toLowerCase().includes(search) ||
        (r.reason || '').toLowerCase().includes(search)
    );

    if (filtered.length === 0) {
        if (empty) {
            empty.classList.remove('hidden');
            grid.appendChild(empty);
        }
        return;
    }
    if (empty) empty.classList.add('hidden');

    filtered.forEach(r => {
        const isOffline = !r.playerId;
        const div = document.createElement('div');
        div.className = `report-card-premium ${r.claimedBy ? 'claimed' : ''} ${isOffline ? 'offline' : ''}`;
        
        const now = Date.now();
        const rTimestamp = r.timestamp || now;
        const diffSec = Math.floor((now - rTimestamp) / 1000);
        let timeStr = 'À l\'instant';
        if (diffSec >= 60) timeStr = `${Math.floor(diffSec/60)}m`;
        if (diffSec >= 3600) timeStr = `${Math.floor(diffSec/3600)}h`;

        const job = r.jobLabel || 'Inconnu';
        const money = r.money !== undefined ? (typeof formatMoney === 'function' ? formatMoney(r.money) : r.money + ' $') : '—';
        const ping = r.ping !== undefined ? r.ping + 'ms' : '—';
        const pName = r.playerName || 'Joueur Inconnu';
        const pId = r.playerId || 'OFF';

        const isMe = r.claimedBy === state.myName;
        
        const statusTag = isOffline ? 
            `<div class="rc-status-tag status-offline">DÉCONNECTÉ</div>` : 
            `<div class="rc-status-tag ${r.claimedBy ? 'status-active' : 'status-open'}">${r.claimedBy ? 'EN COURS' : 'EN ATTENTE'}</div>`;

        div.innerHTML = `
            <!-- HEADER: ID & STATUT -->
            <div class="rc-header">
                <div class="rc-id-pill">ID: #${pId} • Ticket: #${r.id} • ${timeStr}</div>
                ${statusTag}
            </div>

            <!-- SECTION 1: JOUEUR -->
            <div class="rc-player-box">
                <div class="rc-avatar ${isOffline ? 'grayscale' : ''}">${esc(pName[0]?.toUpperCase() || '?')}</div>
                <div class="rc-player-main">
                    <div class="rc-name">${esc(pName)}</div>
                    <div class="rc-player-stats">
                        <span>💼 ${job}</span>
                    </div>
                </div>
            </div>

            <!-- SECTION 2: RAISON -->
            <div class="rc-reason-box">
                <div class="rc-section-title">RAISON DU REPORT</div>
                <div class="rc-reason-text">${esc(r.reason || 'Aucune raison fournie.')}</div>
                ${(r.voice && r.voice.length > 100) ? `
                    <button class="rc-voice-play-btn" onclick="playAudio(this.dataset.voice)" data-voice="${r.voice}">
                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                        ÉCOUTER VOCAL
                    </button>
                ` : ''}
                <div class="rc-location-chip" style="margin-top:8px; font-size:10px; color:var(--muted); display:flex; align-items:center; gap:5px; background:rgba(255,255,255,0.05); padding:4px 8px; border-radius:4px; width:fit-content">
                    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
                    ${r.coords ? `LOC: ${Math.round(r.coords.x)}, ${Math.round(r.coords.y)}, ${Math.round(r.coords.z)}` : 'LOC: Inconnue'}
                </div>
            </div>

            <!-- SECTION 3: ACTIONS -->
            <div class="rc-actions-container ${isOffline ? 'disabled-actions' : ''}">
                <div class="rc-action-group">
                    <span class="rc-group-label">NAVIGATION</span>
                    <div class="rc-button-row">
                        <button class="rc-action-btn primary-btn" onclick="handleReportAction(${r.id}, 'goto')" ${isOffline ? 'disabled' : ''}>
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
                            GOTO
                        </button>
                        <button class="rc-action-btn" onclick="handleReportAction(${r.id}, 'bring')" ${isOffline ? 'disabled' : ''}>
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="17 11 12 6 7 11"/><line x1="12" y1="18" x2="12" y2="6"/></svg>
                            BRING
                        </button>
                    </div>
                </div>

                <div class="rc-action-group">
                    <span class="rc-group-label">MODÉRATION</span>
                    <div class="rc-button-row">
                        <button class="rc-action-btn cyan-btn" onclick="const b=this; b.classList.toggle('active'); sendToClient('spectate', {id: ${pId}, active: b.classList.contains('active')})" ${isOffline ? 'disabled' : ''} title="Spectate">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                            VOIR
                        </button>
                        <button class="rc-action-btn amber-btn" onclick="quickMessage(${pId}, '${esc(pName)}')" ${isOffline ? 'disabled' : ''}>
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
                            MSG
                        </button>
                        <button class="rc-action-btn red-btn" onclick="quickBan({id: ${pId}, name: '${esc(pName)}'})" ${isOffline ? 'disabled' : ''}>
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                            SANCTION
                        </button>
                        <button class="rc-action-btn ${hasPerm('bl.tpzones') ? 'status-online' : 'btn-disabled'}" 
                                onclick="${hasPerm('bl.tpzones') ? `window.showTPZoneMenu('${pId}')` : ''}" 
                                title="${!hasPerm('bl.tpzones') ? 'Permission Insuffisante' : (isOffline ? 'Joueur Déconnecté' : 'TP Joueur vers Zone')}"
                                ${isOffline ? 'disabled' : ''}>
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                ${hasPerm('bl.tpzones') ? '<path d="M12 22s-8-4.5-8-11.8A8 8 0 0 1 12 2a8 8 0 0 1 8 8.2c0 7.3-8 11.8-8 11.8z"/><circle cx="12" cy="10" r="3"/>' : '<rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/>'}
                            </svg>
                            TP ZONE
                        </button>
                    </div>
                </div>
            </div>

            <!-- FOOTER: WORKFLOW -->
            <div class="rc-footer-workflow">
                ${!r.claimedBy ? `
                    <button class="rc-main-btn claim-btn" onclick="handleReportAction(${r.id}, 'claim')">
                        PRENDRE EN CHARGE CE REPORT
                    </button>
                ` : (isMe ? `
                    <div class="rc-btn-split">
                        <button class="rc-split-btn unclaim" onclick="handleReportAction(${r.id}, 'unclaim')">LÂCHER</button>
                        <button class="rc-split-btn close-ticket" onclick="handleReportAction(${r.id}, 'close')">CLÔTURER LE REPORT</button>
                    </div>
                ` : `
                    <div class="rc-claimed-by-other">Pris par <span>${esc(r.claimedBy)}</span></div>
                    <button class="rc-main-btn close-btn" onclick="handleReportAction(${r.id}, 'close')">FORCER LA CLÔTURE</button>
                `)}
            </div>
        `;
        grid.appendChild(div);
    });
}

function renderSMChatPreview() {
    const list = $('sm-chat-messages-preview'); if(!list) return;
    list.innerHTML = '';
    
    // Filter for staffmode channel
    const msgs = (state.staffChat || []).filter(m => m.channel === 'staffmode');

    if (msgs.length === 0) {
        list.innerHTML = '<div class="chat-empty">Aucun message tactique</div>';
        return;
    }

    // Last 3 messages
    const lastMsgs = msgs.slice(-3);
    lastMsgs.forEach(m => {
        const div = document.createElement('div');
        div.className = 'sm-chat-msg';
        div.innerHTML = `<span class="sm-chat-sender">${esc(m.sender_name)}:</span> <span class="sm-chat-txt">${esc(m.message)}</span>`;
        list.appendChild(div);
    });
}

function renderLeaderboard(data) {
    const list = $('leaderboard-list-full');
    if (!list) return;
    list.innerHTML = '';

    if (!data || data.length === 0) {
        list.innerHTML = '<div class="empty-state">Aucune donnée de modération (SQL vide ou nom d\'admin manquant).</div>';
        return;
    }

    data.forEach((s, index) => {
        const item = document.createElement('div');
        item.className = 'leaderboard-item';
        
        let medal = '';
        if (index === 0) medal = '🥇';
        else if (index === 1) medal = '🥈';
        else if (index === 2) medal = '🥉';
        else medal = `<span class="rank-num">#${index + 1}</span>`;

        item.innerHTML = `
            <div class="lb-rank">${medal}</div>
            <div class="lb-info">
                <div class="lb-name">${esc(s.admin_name)}</div>
                <div class="lb-sub">Staff Certifié</div>
            </div>
            <div class="lb-count">
                <span class="lb-num">${s.count}</span>
                <span class="lb-lab">REPORTS</span>
            </div>
        `;
        list.appendChild(item);
    });
}

function updateSMSessionTimer() {
    if (!state.dutyStartTime) {
        $('sm-session-time').textContent = '00:00';
        return;
    }
    const now = Date.now();
    const diff = Math.floor((now - state.dutyStartTime) / 1000);
    const mins = Math.floor(diff / 60);
    const secs = diff % 60;
    $('sm-session-time').textContent = `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
}

const GTACatalog = [
    // SUPERS
    { name: "Adder", model: "adder", type: "Super" },
    { name: "Zentorno", model: "zentorno", type: "Super" },
    { name: "T20", model: "t20", type: "Super" },
    { name: "Osiris", model: "osiris", type: "Super" },
    { name: "Nero", model: "nero", type: "Super" },
    { name: "Nero Custom", model: "nerop2", type: "Super" },
    { name: "Tezeract", model: "tezeract", type: "Super" },
    { name: "Krieger", model: "krieger", type: "Super" },
    { name: "Emerus", model: "emerus", type: "Super" },
    { name: "Ignus", model: "ignus", type: "Super" },
    { name: "Thrax", model: "thrax", type: "Super" },
    { name: "X80 Proto", model: "x80", type: "Super" },
    { name: "Itali RSX", model: "italirsx", type: "Super" },
    { name: "Tempesta", model: "tempesta", type: "Super" },
    { name: "Vagner", model: "vagner", type: "Super" },
    { name: "Entity XF", model: "entityxf", type: "Super" },

    // SPORTS
    { name: "Elegy Retro Custom", model: "elegy", type: "Sport" },
    { name: "Sultan RS", model: "sultanrs", type: "Sport" },
    { name: "Comet Retro", model: "comet3", type: "Sport" },
    { name: "Jester Classic", model: "jester3", type: "Sport" },
    { name: "Kuruma Armored", model: "kuruma2", type: "Sport" },
    { name: "Pariah", model: "pariah", type: "Sport" },
    { name: "GTO", model: "italigto", type: "Sport" },
    { name: "Seven-70", model: "seven70", type: "Sport" },
    { name: "Futo", model: "futo", type: "Sport" },
    { name: "Penetra", model: "penetrator", type: "Sport" },
    { name: "Rapid GT", model: "rapidgt", type: "Sport" },

    // MUSCLE
    { name: "Dominator", model: "dominator", type: "Muscle" },
    { name: "Gauntlet Hellfire", model: "gauntlet4", type: "Muscle" },
    { name: "Sabre Turbo", model: "sabreturbo", type: "Muscle" },
    { name: "Dukes", model: "dukes", type: "Muscle" },
    { name: "Ellie", model: "ellie", type: "Muscle" },
    { name: "Hermes", model: "hermes", type: "Muscle" },
    { name: "Yosemite", model: "yosemite", type: "Muscle" },

    // SUV
    { name: "Toros", model: "toros", type: "SUV" },
    { name: "Dubsta 6x6", model: "dubsta3", type: "SUV" },
    { name: "Baller ST", model: "baller7", type: "SUV" },
    { name: "Granger 3600LX", model: "granger2", type: "SUV" },
    { name: "Jubilee", model: "jubilee", type: "SUV" },
    { name: "Rebla GTS", model: "rebla", type: "SUV" },

    // OFF-ROAD
    { name: "Kamacho", model: "kamacho", type: "Off-Road" },
    { name: "Sandking XL", model: "sandking", type: "Off-Road" },
    { name: "Brawler", model: "brawler", type: "Off-Road" },
    { name: "Trophy Truck", model: "trophytruck", type: "Off-Road" },
    { name: "Freecrawler", model: "freecrawler", type: "Off-Road" },
    { name: "Insurgent", model: "insurgent", type: "Off-Road" },

    // MOTOS
    { name: "Bati 801", model: "bati", type: "Moto" },
    { name: "Sanchez", model: "sanchez", type: "Moto" },
    { name: "Shotaro", model: "shotaro", type: "Moto" },
    { name: "Hakuchou Drag", model: "hakuchou2", type: "Moto" },
    { name: "Manchez Scout", model: "manchez2", type: "Moto" },
    { name: "Shinobi", model: "shinobi", type: "Moto" },
    { name: "Zombie Chopper", model: "zombieb", type: "Moto" },

    // HELICO
    { name: "Buzzard", model: "buzzard", type: "Helico" },
    { name: "Frogger", model: "frogger", type: "Helico" },
    { name: "Maverick", model: "maverick", type: "Helico" },
    { name: "Akula", model: "akula", type: "Helico" },
    { name: "Hunter", model: "hunter", type: "Helico" },
    { name: "Swift Deluxe", model: "swift2", type: "Helico" },

    // AVION
    { name: "Hydra", model: "hydra", type: "Avion" },
    { name: "Lazer", model: "lazer", type: "Avion" },
    { name: "Besra", model: "besra", type: "Avion" },
    { name: "Pyro", model: "pyro", type: "Avion" },
    { name: "Nimbus", model: "nimbus", type: "Avion" },

    // SERVICE / UTILITAIRE
    { name: "Police Cruiser", model: "police", type: "Service" },
    { name: "Police Buffalo", model: "police2", type: "Service" },
    { name: "Police Interceptor", model: "police3", type: "Service" },
    { name: "Ambulance", model: "ambulance", type: "Service" },
    { name: "Fire Truck", model: "firetruk", type: "Service" },
    { name: "Utility Truck", model: "utillitruck", type: "Utilitaire" },
    { name: "Tow Truck", model: "towtruck", type: "Utilitaire" },
    { name: "Mule", model: "mule", type: "Utilitaire" },
    { name: "Pounder", model: "pounder", type: "Utilitaire" },
];

function renderVehicleCatalog(category = 'all', search = '') {
    const grid = $('catalog-grid-container');
    if (!grid) return;
    grid.innerHTML = '';
    
    // Merge base catalog with any custom ones in state
    const fullCatalog = [...GTACatalog, ...(state.customVehicles || [])];

    let filtered = fullCatalog.filter(v => {
        let matchCat = (category === 'all') || (v.type === category);
        let matchSearch = String(v.name).toLowerCase().includes(search.toLowerCase()) || String(v.model).toLowerCase().includes(search.toLowerCase());
        return matchCat && matchSearch;
    });

    if (filtered.length === 0) {
        grid.innerHTML = '<div style="color:var(--muted); font-size:12px; padding:40px; text-align:center; width:100%; grid-column: 1 / -1">Aucun véhicule trouvé dans cette catégorie.</div>';
        return;
    }

    filtered.forEach(v => {
        const div = document.createElement('div');
        div.className = 'cat-card';
        
        div.className = 'cat-card';
        
        // Multi-source image fallback system
        const modelStr = String(v.model).toLowerCase();
        const primaryImg = (v.image && v.image.trim() !== '') ? v.image.trim() : `https://raw.githubusercontent.com/matthias18771/v-vehicle-images/main/images/${modelStr}.png`;
        const fallbackImg = `https://gta-assets.com/img/vehicles/256/${modelStr}.webp`;
        const placeholderImg = `https://via.placeholder.com/256x144/1a1a1a/ffffff?text=${String(v.model).toUpperCase()}`;
        
        div.innerHTML = `
            <div class="cat-img-box">
                <div class="cat-badge">${v.type}</div>
                <img src="${primaryImg}" 
                     onerror="if(!this.src.includes('${fallbackImg}')) { this.src='${fallbackImg}'; } else { this.src='${placeholderImg}'; this.onerror=null; }" 
                     alt="${v.name}"
                     loading="lazy">
            </div>
            <div class="cat-info">
                <span class="cat-name">${v.name}</span>
                <span class="cat-model">${v.model} ${v.props ? '<span style="font-size: 10px; background: rgba(16, 185, 129, 0.2); color: #10b981; padding: 2px 5px; border-radius: 4px; margin-left: 5px; vertical-align: middle;">CUSTOM</span>' : ''}</span>
            </div>
        `;

        if (v.id) {
            const delBtn = document.createElement('div');
            delBtn.className = 'cat-delete-btn';
            delBtn.innerHTML = '<svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><path d="M3 6h18m-2 0v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>';
            delBtn.title = 'Supprimer du catalogue';
            delBtn.onclick = (e) => {
                e.stopPropagation();
                if (!checkDuty()) return;
                sendToClient('removeVehicleFromCatalog', v.id);
                showToast('Suppression du catalogue...', 'info');
            };
            div.appendChild(delBtn);
        }

        div.onclick = () => {
            if (!checkDuty()) return;
            sendToClient('spawnVehicle', { model: v.model, props: v.props });
            showToast('Apparition de ' + v.name + '...', 'info');
            
            // Met à jour la preview sur la page d'accueil
            const vehInput = $('veh-model');
            if (vehInput) vehInput.value = v.model;
            if (typeof updateVehiclePreview === 'function') updateVehiclePreview(v.model);
        };
        grid.appendChild(div);
    });
}

window.renderVehicleCustoms = () => {
    const mods = window.state?.currentVehicleMods || {};
    
    const categories = {
        performance: [
            { label: 'Moteur', mod: 11, prop: 'modEngine', isCycle: true },
            { label: 'Freins', mod: 12, prop: 'modBrakes', isCycle: true },
            { label: 'Transmission', mod: 13, prop: 'modTransmission', isCycle: true },
            { label: 'Suspension', mod: 15, prop: 'modSuspension', isCycle: true },
            { label: 'Blindage', mod: 16, prop: 'modArmor', isCycle: true },
            { label: 'Turbo', mod: 18, isToggle: true, prop: 'modTurbo' }
        ],
        visual: [
            { label: 'Aileron', mod: 0, prop: 'modSpoilers', isCycle: true },
            { label: 'Pare-chocs Avant', mod: 1, prop: 'modFrontBumper', isCycle: true },
            { label: 'Pare-chocs Arrière', mod: 2, prop: 'modRearBumper', isCycle: true },
            { label: 'Bas de caisse', mod: 3, prop: 'modSideSkirt', isCycle: true },
            { label: 'Échappement', mod: 4, prop: 'modExhaust', isCycle: true },
            { label: 'Châssis / Cage', mod: 5, prop: 'modFrame', isCycle: true },
            { label: 'Calandre', mod: 6, prop: 'modGrille', isCycle: true },
            { label: 'Capot', mod: 7, prop: 'modHood', isCycle: true },
            { label: 'Ailes Gauche', mod: 8, prop: 'modFender', isCycle: true },
            { label: 'Ailes Droite', mod: 9, prop: 'modRightFender', isCycle: true },
            { label: 'Toit', mod: 10, prop: 'modRoof', isCycle: true },
            { label: 'Klaxon', mod: 14, prop: 'modHorns', isCycle: true },
            { label: 'Supports Plaque', mod: 25, prop: 'modPlateHolder', isCycle: true },
            { label: 'Plaques Perso', mod: 26, prop: 'modVanityPlate', isCycle: true },
            { label: 'Design Intérieur', mod: 27, prop: 'modTrimA', isCycle: true },
            { label: 'Ornements', mod: 28, prop: 'modOrnaments', isCycle: true },
            { label: 'Tableau de bord', mod: 29, prop: 'modDashboard', isCycle: true },
            { label: 'Cadrans', mod: 30, prop: 'modDial', isCycle: true },
            { label: 'Haut-parleurs Portes', mod: 31, prop: 'modDoorSpeaker', isCycle: true },
            { label: 'Sièges', mod: 32, prop: 'modSeats', isCycle: true },
            { label: 'Volant', mod: 33, prop: 'modSteeringWheel', isCycle: true },
            { label: 'Levier de vitesse', mod: 34, prop: 'modShifterLeavers', isCycle: true },
            { label: 'Plaques Coffre', mod: 35, prop: 'modAPlate', isCycle: true },
            { label: 'Haut-parleurs', mod: 36, prop: 'modSpeakers', isCycle: true },
            { label: 'Coffre', mod: 37, prop: 'modTrunk', isCycle: true },
            { label: 'Hydraulique', mod: 38, prop: 'modHydraulics', isCycle: true },
            { label: 'Bloc Moteur', mod: 39, prop: 'modEngineBlock', isCycle: true },
            { label: 'Filtre à Air', mod: 40, prop: 'modAirFilter', isCycle: true },
            { label: 'Barres Anti-Rapprochement', mod: 41, prop: 'modStruts', isCycle: true },
            { label: 'Couvre-Arc', mod: 42, prop: 'modArchCover', isCycle: true },
            { label: 'Antennes', mod: 43, prop: 'modAerials', isCycle: true },
            { label: 'Garniture Extérieure', mod: 44, prop: 'modTrimB', isCycle: true },
            { label: 'Réservoir', mod: 45, prop: 'modTank', isCycle: true },
            { label: 'Fenêtres', mod: 46, prop: 'modWindows', isCycle: true },
            { label: 'Livrée', mod: 48, prop: 'modLivery', isCycle: true },
            { label: 'Peinture Primaire', type: 'color', mode: 'primary' },
            { label: 'Peinture Secondaire', type: 'color', mode: 'secondary' },
            { label: 'Peinture Intérieure', type: 'color', mode: 'interior' },
            { label: 'Teinte des Vitres', mod: 'tint', prop: 'windowTint' },
            { label: 'Type de Plaque', mod: 'plate', prop: 'plateIndex' }
        ],
        neons: [
            { label: 'Néon Gauche', type: 'neon', index: 0 },
            { label: 'Néon Droit', type: 'neon', index: 1 },
            { label: 'Néon Avant', type: 'neon', index: 2 },
            { label: 'Néon Arrière', type: 'neon', index: 3 }
        ],
        wheels: [
            { label: 'Type de Roues', type: 'wheelType' },
            { label: 'Jantes', mod: 23, prop: 'modWheels', isCycle: true },
            { label: 'Jantes Arrière (Moto)', mod: 24, prop: 'modBackWheels', isCycle: true },
            { label: 'Couleur Jantes', type: 'color', mode: 'wheels' }
        ]
    };

    for (const [cat, items] of Object.entries(categories)) {
        const panel = $(`vc-content-${cat}`);
        if (!panel) continue;
        panel.innerHTML = '<div class="vc-panel-grid"></div>';
        const grid = panel.querySelector('.vc-panel-grid');

        // Add Neon Color Picker to Neons tab
        if (cat === 'neons') {
            const colorPicker = document.createElement('div');
            colorPicker.className = 'vc-item full-width';
            colorPicker.innerHTML = `
                <div class="vc-item-title">Couleur des Néons</div>
                <div class="v-color-palette" style="margin-top: 10px;">
                    <div class="v-color-swatch" style="background: #ffffff" onclick="sendToClient('setNeonColor', {r:255, g:255, b:255}); setTimeout(refreshCurrentVehicleMods, 200)"></div>
                    <div class="v-color-swatch" style="background: #ef4444" onclick="sendToClient('setNeonColor', {r:239, g:68, b:68}); setTimeout(refreshCurrentVehicleMods, 200)"></div>
                    <div class="v-color-swatch" style="background: #3b82f6" onclick="sendToClient('setNeonColor', {r:59, g:130, b:246}); setTimeout(refreshCurrentVehicleMods, 200)"></div>
                    <div class="v-color-swatch" style="background: #10b981" onclick="sendToClient('setNeonColor', {r:16, g:185, b:129}); setTimeout(refreshCurrentVehicleMods, 200)"></div>
                    <div class="v-color-swatch" style="background: #f59e0b" onclick="sendToClient('setNeonColor', {r:245, g:158, b:11}); setTimeout(refreshCurrentVehicleMods, 200)"></div>
                    <div class="v-color-swatch" style="background: #8b5cf6" onclick="sendToClient('setNeonColor', {r:139, g:92, b:246}); setTimeout(refreshCurrentVehicleMods, 200)"></div>
                    <div class="v-color-swatch" style="background: #06b6d4" onclick="sendToClient('setNeonColor', {r:6, g:182, b:212}); setTimeout(refreshCurrentVehicleMods, 200)"></div>
                    <div class="v-color-swatch" style="background: #ec4899" onclick="sendToClient('setNeonColor', {r:236, g:72, b:153}); setTimeout(refreshCurrentVehicleMods, 200)"></div>
                </div>
            `;
            grid.appendChild(colorPicker);
        }

        items.forEach(item => {
            let info = { total: 0, names: {} };
            if (item.isCycle || item.isToggle) {
                if (mods.modLabels) {
                    info = mods.modLabels[item.mod] || mods.modLabels[item.mod.toString()] || info;
                }
                
                // Force defaults for critical parts that might return 0 from FiveM native
                if (info.total === 0) {
                    if (item.mod === 11 || item.mod === 15) info.total = 4;
                    else if (item.mod === 12 || item.mod === 13) info.total = 3;
                    else if (item.mod === 16) info.total = 5;
                    else if (item.mod === 23 || item.mod === 24) info.total = 50;
                }

                // Skip rendering if not available and it's a specific vehicle mod
                if (info.total === 0 && !item.isToggle && item.mod !== 'tint' && item.mod !== 'plate') return;
            }

            const div = document.createElement('div');
            div.className = 'vc-item';
            
            let currentVal = -1;
            if (item.prop) currentVal = mods[item.prop] !== undefined ? mods[item.prop] : -1;
            if (item.type === 'neon') currentVal = mods.neonEnabled && mods.neonEnabled[item.index] ? 1 : 0;
            
            const isModified = currentVal !== -1 && currentVal !== 0 && currentVal !== false;
            if (isModified) div.classList.add('is-modified');

            let controlsHTML = '';
            if (item.isToggle) {
                const isActive = mods[item.prop] === 1 || mods[item.prop] === true;
                controlsHTML = `
                    <button class="vc-btn ${isActive ? 'active' : ''}" onclick="this.parentElement.querySelectorAll('.vc-btn').forEach(b=>b.classList.remove('active')); this.classList.add('active'); sendToClient('setVehicleMod', {modType: ${item.mod}, index: 1}); setTimeout(refreshCurrentVehicleMods, 200)">Activer</button>
                    <button class="vc-btn ${!isActive ? 'active' : ''}" onclick="this.parentElement.querySelectorAll('.vc-btn').forEach(b=>b.classList.remove('active')); this.classList.add('active'); sendToClient('setVehicleMod', {modType: ${item.mod}, index: -1}); setTimeout(refreshCurrentVehicleMods, 200)">Désactiver</button>
                `;
            } else if (item.type === 'neon') {
                const isActive = mods.neonEnabled && mods.neonEnabled[item.index];
                controlsHTML = `
                    <button class="vc-btn ${isActive ? 'active' : ''}" onclick="this.parentElement.querySelectorAll('.vc-btn').forEach(b=>b.classList.remove('active')); this.classList.add('active'); sendToClient('setVehicleMod', {modType: 'neon', index: ${item.index}, enabled: true}); setTimeout(refreshCurrentVehicleMods, 200)">On</button>
                    <button class="vc-btn ${!isActive ? 'active' : ''}" onclick="this.parentElement.querySelectorAll('.vc-btn').forEach(b=>b.classList.remove('active')); this.classList.add('active'); sendToClient('setVehicleMod', {modType: 'neon', index: ${item.index}, enabled: false}); setTimeout(refreshCurrentVehicleMods, 200)">Off</button>
                `;
            } else if (item.isCycle) {
                const current = (mods[item.prop] !== undefined ? mods[item.prop] : -1);
                const total = info.total || 0;
                const modName = current === -1 ? 'DÉFAUT' : (info.names[current.toString()] || info.names[current] || `VARIANTE ${current + 1}`);
                
                if (total === 0 && item.mod !== 'tint' && item.mod !== 'plate') {
                    return; // Safety skip if somehow passed the first check
                } else {
                    // Create progress segments
                    let segments = '';
                    const maxSegments = 10;
                    for(let i=0; i<maxSegments; i++) {
                        const active = total > 0 && (i / maxSegments) <= ((current + 1) / total);
                        segments += `<div class="vc-segment ${active ? 'active' : ''}"></div>`;
                    }

                    controlsHTML = `
                        <div class="vc-cycle-container">
                            <div class="vc-cycle">
                                <button class="vc-cycle-btn" onclick="sendToClient('setVehicleMod', {modType: ${item.mod}, index: -1}); setTimeout(refreshCurrentVehicleMods, 200)" style="margin-right: 6px; background: rgba(255,255,255,0.05); color: #94a3b8; border-color: rgba(255,255,255,0.1); font-size: 8px; font-weight: 800; padding: 0 6px; width: auto; height: 22px; border-radius: 4px; text-transform: uppercase;">Stock</button>
                                <button class="vc-cycle-btn" onclick="sendToClient('setVehicleMod', {modType: ${item.mod}, index: ${current - 1}, cycle: true}); setTimeout(refreshCurrentVehicleMods, 200)">
                                    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><path d="M15 18l-6-6 6-6"/></svg>
                                </button>
                                <div class="vc-cycle-val">
                                    <div class="vc-mod-name">${modName}</div>
                                    <div class="vc-mod-count">${current + 1} / ${total}</div>
                                </div>
                                <button class="vc-cycle-btn" onclick="sendToClient('setVehicleMod', {modType: ${item.mod}, index: ${current + 1}, cycle: true}); setTimeout(refreshCurrentVehicleMods, 200)">
                                    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><path d="M9 18l6-6-6-6"/></svg>
                                </button>
                                <button class="vc-cycle-btn" onclick="sendToClient('setVehicleMod', {modType: ${item.mod}, index: ${total - 1}}); setTimeout(refreshCurrentVehicleMods, 200)" style="margin-left: 6px; background: linear-gradient(135deg, rgba(239,68,68,0.2) 0%, rgba(220,38,38,0.4) 100%); color: #fca5a5; border-color: rgba(239,68,68,0.3); font-size: 8px; font-weight: 800; padding: 0 6px; width: auto; height: 22px; border-radius: 4px; text-transform: uppercase; box-shadow: 0 0 8px rgba(239,68,68,0.15);">Max</button>
                            </div>
                            <div class="vc-progress-bar">${segments}</div>
                        </div>
                    `;
                }
            } else if (item.type === 'wheelType') {
                const currentType = mods.wheelsType || 0;
                controlsHTML = `
                    <select class="vt-input" style="width: 100%; height: 35px; background: rgba(0,0,0,0.3); color: white; border: 1px solid rgba(255,255,255,0.1); border-radius: 8px; padding: 0 10px;" onchange="sendToClient('setVehicleMod', {modType: 'wheelType', index: parseInt(this.value)}); setTimeout(refreshCurrentVehicleMods, 200)">
                        <option value="0" ${currentType === 0 ? 'selected' : ''}>Sport</option>
                        <option value="1" ${currentType === 1 ? 'selected' : ''}>Muscle</option>
                        <option value="2" ${currentType === 2 ? 'selected' : ''}>Lowrider</option>
                        <option value="3" ${currentType === 3 ? 'selected' : ''}>SUV</option>
                        <option value="4" ${currentType === 4 ? 'selected' : ''}>Off-road</option>
                        <option value="5" ${currentType === 5 ? 'selected' : ''}>Tuning</option>
                        <option value="6" ${currentType === 6 ? 'selected' : ''}>Bike Wheels</option>
                        <option value="7" ${currentType === 7 ? 'selected' : ''}>High End</option>
                    </select>
                `;
            } else if (item.type === 'color') {
                if (item.mode === 'wheels') {
                    controlsHTML = `
                        <div class="v-color-palette mini">
                            <div class="v-color-swatch" style="background: #ffffff" onclick="sendToClient('setVehicleMod', {modType: 'color', mode: 'wheels', index: 111}); setTimeout(refreshCurrentVehicleMods, 200)"></div>
                            <div class="v-color-swatch" style="background: #1a1a1a" onclick="sendToClient('setVehicleMod', {modType: 'color', mode: 'wheels', index: 0}); setTimeout(refreshCurrentVehicleMods, 200)"></div>
                            <div class="v-color-swatch" style="background: #ef4444" onclick="sendToClient('setVehicleMod', {modType: 'color', mode: 'wheels', index: 27}); setTimeout(refreshCurrentVehicleMods, 200)"></div>
                            <div class="v-color-swatch" style="background: #3b82f6" onclick="sendToClient('setVehicleMod', {modType: 'color', mode: 'wheels', index: 64}); setTimeout(refreshCurrentVehicleMods, 200)"></div>
                            <div class="v-color-swatch" style="background: #f59e0b" onclick="sendToClient('setVehicleMod', {modType: 'color', mode: 'wheels', index: 88}); setTimeout(refreshCurrentVehicleMods, 200)"></div>
                        </div>
                    `;
                } else {
                    controlsHTML = `
                        <div class="v-color-palette mini">
                            <div class="v-color-swatch" style="background: #ffffff" onclick="sendToClient('setVehicleMod', {modType: 'color', mode: '${item.mode}', r:255, g:255, b:255}); setTimeout(refreshCurrentVehicleMods, 200)"></div>
                            <div class="v-color-swatch" style="background: #1a1a1a" onclick="sendToClient('setVehicleMod', {modType: 'color', mode: '${item.mode}', r:0, g:0, b:0}); setTimeout(refreshCurrentVehicleMods, 200)"></div>
                            <div class="v-color-swatch" style="background: #ef4444" onclick="sendToClient('setVehicleMod', {modType: 'color', mode: '${item.mode}', r:239, g:68, b:68}); setTimeout(refreshCurrentVehicleMods, 200)"></div>
                            <div class="v-color-swatch" style="background: #3b82f6" onclick="sendToClient('setVehicleMod', {modType: 'color', mode: '${item.mode}', r:59, g:130, b:246}); setTimeout(refreshCurrentVehicleMods, 200)"></div>
                            <div class="v-color-swatch" style="background: #f59e0b" onclick="sendToClient('setVehicleMod', {modType: 'color', mode: '${item.mode}', r:245, g:158, b:11}); setTimeout(refreshCurrentVehicleMods, 200)"></div>
                        </div>
                    `;
                }
            } else if (item.mod === 'tint') {
                const current = mods[item.prop] || 0;
                controlsHTML = `
                    <button class="vc-btn ${current === 0 ? 'active' : ''}" onclick="sendToClient('setVehicleMod', {modType: 'tint', index: 0}); setTimeout(refreshCurrentVehicleMods, 200)">None</button>
                    <button class="vc-btn ${current === 1 ? 'active' : ''}" onclick="sendToClient('setVehicleMod', {modType: 'tint', index: 1}); setTimeout(refreshCurrentVehicleMods, 200)">Limo</button>
                    <button class="vc-btn ${current === 2 ? 'active' : ''}" onclick="sendToClient('setVehicleMod', {modType: 'tint', index: 2}); setTimeout(refreshCurrentVehicleMods, 200)">Dark</button>
                    <button class="vc-btn ${current === 3 ? 'active' : ''}" onclick="sendToClient('setVehicleMod', {modType: 'tint', index: 3}); setTimeout(refreshCurrentVehicleMods, 200)">Med</button>
                `;
            } else if (item.mod === 'plate') {
                const current = mods[item.prop] || 0;
                controlsHTML = `
                    <button class="vc-btn ${current === 0 ? 'active' : ''}" onclick="sendToClient('setVehicleMod', {modType: 'plate', index: 0}); setTimeout(refreshCurrentVehicleMods, 200)">B/W</button>
                    <button class="vc-btn ${current === 1 ? 'active' : ''}" onclick="sendToClient('setVehicleMod', {modType: 'plate', index: 1}); setTimeout(refreshCurrentVehicleMods, 200)">Y/B</button>
                    <button class="vc-btn ${current === 4 ? 'active' : ''}" onclick="sendToClient('setVehicleMod', {modType: 'plate', index: 4}); setTimeout(refreshCurrentVehicleMods, 200)">B/W 2</button>
                `;
            } else {
                const currentMod = mods[item.prop] !== undefined ? mods[item.prop] : -1;
                controlsHTML = `
                    <button class="vc-btn ${currentMod === -1 ? 'active' : ''}" onclick="this.parentElement.querySelectorAll('.vc-btn').forEach(b=>b.classList.remove('active')); this.classList.add('active'); sendToClient('setVehicleMod', {modType: ${item.mod}, index: -1}); setTimeout(refreshCurrentVehicleMods, 200)">Stock</button>
                    <button class="vc-btn ${currentMod === 0 ? 'active' : ''}" onclick="this.parentElement.querySelectorAll('.vc-btn').forEach(b=>b.classList.remove('active')); this.classList.add('active'); sendToClient('setVehicleMod', {modType: ${item.mod}, index: 0}); setTimeout(refreshCurrentVehicleMods, 200)">1</button>
                    <button class="vc-btn ${currentMod === 1 ? 'active' : ''}" onclick="this.parentElement.querySelectorAll('.vc-btn').forEach(b=>b.classList.remove('active')); this.classList.add('active'); sendToClient('setVehicleMod', {modType: ${item.mod}, index: 1}); setTimeout(refreshCurrentVehicleMods, 200)">2</button>
                    <button class="vc-btn ${currentMod === 2 ? 'active' : ''}" onclick="this.parentElement.querySelectorAll('.vc-btn').forEach(b=>b.classList.remove('active')); this.classList.add('active'); sendToClient('setVehicleMod', {modType: ${item.mod}, index: 2}); setTimeout(refreshCurrentVehicleMods, 200)">3</button>
                    <button class="vc-btn ${currentMod === 3 ? 'active' : ''}" onclick="this.parentElement.querySelectorAll('.vc-btn').forEach(b=>b.classList.remove('active')); this.classList.add('active'); sendToClient('setVehicleMod', {modType: ${item.mod}, index: 3}); setTimeout(refreshCurrentVehicleMods, 200)">Max</button>
                `;
            }

            div.innerHTML = `
                <div class="vc-item-title">${item.label}</div>
                <div class="vc-item-controls">
                    ${controlsHTML}
                </div>
            `;
            grid.appendChild(div);
        });
    }
};

function updateVehiclePreview(model) {
    const img = $('v-preview-img');
    const placeholder = $('v-preview-placeholder');
    if (!img || !placeholder) return;

    if (!model || model.length < 2) {
        img.classList.add('hidden');
        img.src = '';
        placeholder.classList.remove('hidden');
        return;
    }

    const modelClean = model.toLowerCase().trim();
    const primaryImg = `https://raw.githubusercontent.com/matthias18771/v-vehicle-images/main/images/${modelClean}.png`;
    const fallbackImg = `https://gta-assets.com/img/vehicles/256/${modelClean}.webp`;
    
    img.src = primaryImg;
    img.classList.remove('hidden');
    placeholder.classList.add('hidden');

    img.onerror = () => {
        if (!img.src.includes(fallbackImg)) {
            img.src = fallbackImg;
        } else {
            img.classList.add('hidden');
            img.src = '';
            placeholder.classList.remove('hidden');
        }
    };
}

function initCatalog() {
    renderVehicleCatalog();
}

document.addEventListener('DOMContentLoaded', () => {
    setTimeout(initCatalog, 500);
});
