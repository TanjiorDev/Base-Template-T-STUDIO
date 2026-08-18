//  BLOODADMIN — HTML/JS/APP.JS
// ============================================================

window.hasPerm = (perm) => {
    if (!state.myPerms) return false;
    return state.myPerms[perm] === true;
};

window.addEventListener('message', e => {
    const d = e.data;
    if (d.action !== 'updateMetrics' && d.action !== 'updateServerMetrics') console.log('[bl_admin] Received NUI Message:', d.action);
    
    if (d.action === 'openMenu')      handleOpen(d);
    if (d.action === 'closeMenu')     handleClose();
    if (d.action === 'showAnnounce')  showServerAnnounce(d.admin, d.message);
    if (d.action === 'syncWorldState') {
        if (typeof syncWorldStateUI === 'function') syncWorldStateUI(d.worldState);
    }
    if (d.action === 'addLiveLog') {
        if (!state.logs) state.logs = [];
        state.logs.unshift(d.liveLog);
        if (state.logs.length > 150) state.logs = state.logs.slice(0, 150);
        if (typeof renderLogs === 'function') renderLogs();
        if (typeof renderDashActivity === 'function') renderDashActivity();
    }
    
    if (d.action === 'revokeAccess') {
        // Reset all local state — this player is no longer staff
        state.myGrade = null;
        state.myPerms = {};
        handleClose();
        showToast('Votre accès au panel administrateur a été révoqué.', 'error');
    }
    
    if (d.action === 'updateConfig')  { 
        state.config = d.config; 
        if (d.grade) state.myGrade = d.grade;
        
        if (state.myGrade) {
            state.myPerms = state.config.Permissions?.[state.myGrade] || {};
        }
        
        // AUTO REFRESH EVERYTHING ACROSS ALL TABS
        if (!state.isUpdatingLocalPerm) {
            updateUIPermissions(state.myGrade);
            if (typeof renderPermissions === 'function') renderPermissions();
        }
        
        // Refresh lists that show grade badges/icons and action buttons
        if (typeof renderPlayers === 'function') renderPlayers();
        if (typeof renderStaffMembers === 'function') renderStaffMembers();
        if (typeof renderReports === 'function') renderReports();
        if (typeof renderSMReportsV4 === 'function') renderSMReportsV4();
        
        // Refresh dashboard stats that might be affected
        if (typeof updateDashStats === 'function') updateDashStats();
        
        console.log('[bl_admin] Global UI Refresh triggered by Config update (Real-time perms synced).');
    }
    
    if (d.action === 'updateAllStaff') { 
        state.allStaff = Array.isArray(d.staff) ? d.staff : []; 
        
        // Sync my duty state from server list
        if (state.myId !== undefined) {
            const me = state.allStaff.find(s => parseInt(s.id) === parseInt(state.myId));
            if (me) {
                const newDuty = me.inService === true;
                if (state.myDuty !== newDuty) {
                    state.myDuty = newDuty;
                    syncDutyUI();
                }
            }
        }
        
        renderStaffMembers(); 
    }
    
    if (d.action === 'toast') {
        showToast(d.message, d.type || 'info');
    }

    if (d.action === 'showJailOverlay') {
        const overlay = $('jail-overlay');
        if (overlay) {
            overlay.classList.remove('hidden');
            let expiresAt = d.expires;
            if (window.jailInterval) clearInterval(window.jailInterval);
            
            const timerEl = $('jail-timer');
            const updateTimer = () => {
                let now = Math.floor(Date.now() / 1000);
                let diff = expiresAt - now;
                if (diff <= 0) {
                    diff = 0;
                    clearInterval(window.jailInterval);
                }
                let m = Math.floor(diff / 60).toString().padStart(2, '0');
                let s = (diff % 60).toString().padStart(2, '0');
                if (timerEl) timerEl.innerText = `${m}:${s}`;
            };
            updateTimer();
            window.jailInterval = setInterval(updateTimer, 1000);
        }
    }

    if (d.action === 'hideJailOverlay') {
        const overlay = $('jail-overlay');
        if (overlay) overlay.classList.add('hidden');
        if (window.jailInterval) clearInterval(window.jailInterval);
    }

    if (d.action === 'setGrade') {
        state.myGrade = d.grade;
        state.myPerms = d.perms;
        updateUIPermissions(d.grade);
        if (typeof renderPlayers === 'function') renderPlayers();
        if (typeof renderReports === 'function') renderReports();
    }
    
    if (d.action === 'updatePlayers') {
        state.players = Array.isArray(d.players) ? d.players : [];
        renderPlayers();
        updateDashStats();
        renderSMPlayers();
        if (typeof renderSMReportsV4 === 'function') renderSMReportsV4();
    }
    
    if (d.action === 'updateOfflinePlayers') {
        state.offlinePlayers = Array.isArray(d.offlineList) ? d.offlineList : [];
        renderPlayers();
    }
    
    if (d.action === 'updateReports') {
        const oldReports = state.reports || [];
        state.reports = Array.isArray(d.reports) ? d.reports : [];
        state.totalReports = d.total || state.reports.length;
        
        const newReports = state.reports.filter(nr => !oldReports.some(or => or.id === nr.id));
        
        if (typeof renderReports === 'function') renderReports();
        if (typeof renderSMReportsV4 === 'function') renderSMReportsV4();
        updateDashStats();

        if (newReports.length > 0) {
            const last = newReports[newReports.length - 1];
            if (state.myDuty) showToast(`Nouveau report de <b>${esc(last.playerName)}</b> !`, 'warning');
        }

        if (typeof updateReportsHUD === 'function') updateReportsHUD(newReports.length > 0);
        state.lastReportCount = state.reports.length;
    }
    
    if (d.action === 'updateReportsLeaderboard') {
        renderLeaderboard(d.data);
    }
    
    if (d.action === 'updateResources') {
        state.allResources = Array.isArray(d.resources) ? d.resources : [];
        renderResources();
        updateDashStats();
    }
    
    if (d.action === 'updateBans') {
        state.bans = Array.isArray(d.bans) ? d.bans : [];
        renderBans();
        if (typeof updateDashStats === 'function') updateDashStats();
        
        // Auto-refresh offline list if currently viewing it
        if (state.playersFilter === 'offline') {
            sendToClient('requestOfflinePlayers');
        }
    }
    
    if (d.action === 'updateWarns') {
        state.warns = Array.isArray(d.warns) ? d.warns : [];
        renderWarns();
    }

    if (d.action === 'updateJails') {
        state.jails = d.jails || {};
        renderJails();
        updateSanctionStats();
    }

    if (d.action === 'updateGhosts') {
        state.ghosts = d.ghosts || {};
        renderGhosts();
        updateSanctionStats();
    }
    
    if (d.action === 'updateLogs') {
        state.logs = Array.isArray(d.logs) ? d.logs : [];
        renderLogs();
        if (typeof updateDashStats === 'function') updateDashStats();
    }
    
    if (d.action === 'updateCatalog') {
        state.customVehicles = Array.isArray(d.vehicles) ? d.vehicles : (Object.values(d.vehicles || {}));
        if (typeof renderVehicleCatalog === 'function') {
            renderVehicleCatalog(document.querySelector('.cat-filter.active')?.dataset.category || 'all', $('catalog-search')?.value || '');
        }
    }
    
        if (d.action === 'updateStaffChat') {
            state.staffChat = Array.isArray(d.messages) ? d.messages : [];
            renderStaffChat();
            if (state.staffChat.length > 0) {
                const last = state.staffChat[state.staffChat.length - 1];
                if (last.sender_id != state.myId) showToast(`Nouveau message de ${last.sender_name}`, 'info');
            }
            if (typeof renderSMChatPreview === 'function') renderSMChatPreview();
        }

        if (d.action === 'updateServerMetrics') {
            const m = d.data;
            if (m.serverMem !== undefined) {
                const memVal = parseFloat(m.serverMem);
                const totalMem = 16384; // Assuming 16GB total
                const memPct = Math.round((memVal / totalMem) * 100);
                if ($('health-mem-pct')) $('health-mem-pct').innerText = memPct + '%';
                if ($('bar-mem')) $('bar-mem').style.width = Math.min(100, memPct) + '%';
            }
            
            if (m.fxMem !== undefined) {
                if ($('health-fx-val')) $('health-fx-val').innerText = m.fxMem + ' MB';
                if ($('bar-fx')) $('bar-fx').style.width = Math.min(100, (parseFloat(m.fxMem) / 4096) * 100) + '%';
            }
            
            if (m.nodeMem !== undefined) {
                if ($('health-node-val')) $('health-node-val').innerText = m.nodeMem + ' MB';
                if ($('bar-node')) $('bar-node').style.width = Math.min(100, (parseFloat(m.nodeMem) / 512) * 100) + '%';
            }
            
            if (m.avgPing !== undefined) {
                if ($('health-ping-val')) $('health-ping-val').innerText = m.avgPing + 'ms';
                if ($('bar-ping')) $('bar-ping').style.width = Math.min(100, (m.avgPing / 200) * 100) + '%';
                if ($('dc-avg-ping')) $('dc-avg-ping').innerText = m.avgPing + 'ms';
            }

            if (m.totalPlayers !== undefined) {
                if ($('dc-online')) $('dc-online').innerText = m.totalPlayers;
                if ($('topbar-online')) $('topbar-online').innerText = m.totalPlayers;
            }
            
            // New Dashboard Data
            if (m.totalReports !== undefined) state.totalReports = m.totalReports;
            if (m.newPlayersToday !== undefined) state.newPlayersToday = m.newPlayersToday;
            if (m.staffInService !== undefined) state.staffInService = m.staffInService;
            if (m.myActions !== undefined) state.myActions = m.myActions;
            
            updateDashStats();

            if (m.staffInService !== undefined && $('qi-staff-count')) $('qi-staff-count').innerText = m.staffInService;
            
            // Topbar
            if (m.ping !== undefined && $('ping-val')) $('ping-val').innerText = m.ping + 'ms';
            if (m.serverMem !== undefined && $('mem-val')) $('mem-val').innerText = m.serverMem + ' MB';
            
            // Uptime
            if (m.uptime !== undefined) {
                const totalSeconds = m.uptime;
                const hours = Math.floor(totalSeconds / 3600);
                const minutes = Math.floor((totalSeconds % 3600) / 60);
                if ($('qi-uptime')) $('qi-uptime').innerText = `${hours}h ${minutes}m`;
            }
        }

        if (d.action === 'openPlayerReport') {
            console.log('[bl_admin] Opening Player Report UI');
            $('player-report-ui').classList.remove('hidden');
            $('pru-reason').value = '';
            state.myCoords = d.coords;
            state.pendingVoice = null;
            $('pru-reason').focus();
        }
        if (d.action === 'resetTools') {
            document.querySelectorAll('.sm-action-btn-v4.active').forEach(b => b.classList.remove('active'));
            // Also reset checkboxes in tools tab
            if ($('noclip-toggle-v3')) $('noclip-toggle-v3').checked = false;
            if ($('godmode-toggle-v3')) $('godmode-toggle-v3').checked = false;
            if ($('invis-toggle-v3')) $('invis-toggle-v3').checked = false;
            if ($('esp-toggle-v3')) $('esp-toggle-v3').checked = false;
            if ($('blackout-toggle-v3')) $('blackout-toggle-v3').checked = false;
            updateStaffHUD();
        }
        if (d.action === 'syncTool') {
            if (!state.activeTools) state.activeTools = {};
            state.activeTools[d.tool] = d.active;

            const btn = $(`sm-tool-${d.tool}`);
            if (btn) {
                if (d.active) btn.classList.add('active');
                else btn.classList.remove('active');
            }
            // Also sync checkboxes in tools tab
            const toolId = d.tool === 'vanish' ? 'invis' : d.tool;
            const checkbox = $(`${toolId}-toggle-v3`);
            if (checkbox) checkbox.checked = d.active;
            
            updateStaffHUD();
        }
    });

function handleOpen(data) {
    console.log('[bl_admin] handleOpen received Config:', data.config?.Permissions?.boss?._color, data.config?.Permissions?.boss?._icon);
    const overlay = $('overlay');
    overlay.classList.remove('hidden');
    overlay.classList.add('animating-in');
    
    state.players = Array.isArray(data.players) ? data.players : [];
    state.staff   = Array.isArray(data.staff)   ? data.staff   : [];
    state.bans    = Array.isArray(data.bans)    ? data.bans    : [];
    state.allResources = Array.isArray(data.resources) ? data.resources : [];
    if (data.config) state.config = data.config;
    if (data.grade) {
        state.myGrade = data.grade;
        state.myPerms = state.config.Permissions?.[data.grade] || {};
    }
    if (data.id !== undefined) state.myId = data.id;
    if (data.duty !== undefined) state.myDuty = data.duty;
    if (data.name) state.myName = data.name;
    if (data.myActions !== undefined) state.myActions = data.myActions;

    if ($('sm-player-name')) $('sm-player-name').textContent = state.myName || 'Staff';
    state.reports = Array.isArray(data.reports) ? data.reports : (Object.values(data.reports || {}));
    state.customVehicles = Array.isArray(data.customVehicles) ? data.customVehicles : (Object.values(data.customVehicles || {}));
    state.lastReportCount = state.reports.length;

    state.staffChat = [];
    renderStaffChat();

    // UI Updates
    updateUIPermissions(state.myGrade);
    renderPlayers();
    renderStaff();
    renderBans();
    renderResources();
    renderSMPlayers();
    if (typeof renderReports === 'function') renderReports();
    if (typeof renderSMReportsV4 === 'function') renderSMReportsV4();
    if (typeof renderSMChatPreview === 'function') renderSMChatPreview();
    if (typeof renderVehicleCatalog === 'function') renderVehicleCatalog();
    
    updateDashStats();
    updateReportsHUD(false);
    buildActions();
    
    // Pre-fetch offline players in the background instantly
    sendToClient('requestOfflinePlayers');

    // Auto-detect current vehicle for preview
    if (data.currentVehicle) {
        const modelInput = $('veh-model');
        if (modelInput) {
            modelInput.value = data.currentVehicle;
            if (typeof updateVehiclePreview === 'function') {
                updateVehiclePreview(data.currentVehicle);
            }
        }
    }

    // Explicitly request data for dashboard
    sendToClient('getLogs', { category: 'all' });
    sendToClient('getStaffChat');
    sendToClient('requestSanctions');

    // AUTO-DETECT CUSTOMS ON OPEN
    const activeTab = document.querySelector('.nav-item.active')?.dataset.tab;
    const activePill = document.querySelector('#tab-vehicles .pill.active')?.dataset.vsub;
    
    if (activeTab === 'vehicles' && activePill === 'customs') {
        $('panel').classList.add('customs-mode');
        setTimeout(() => {
            if (typeof refreshCurrentVehicleMods === 'function') refreshCurrentVehicleMods();
        }, 200);
    }
    
    setTimeout(() => overlay.classList.remove('animating-in'), 400);
}

function handleClose() {
    console.log('[bl_admin] Hiding NUI Overlay...');
    const overlay = $('overlay');
    overlay.classList.add('animating-out');
    setTimeout(() => {
        overlay.classList.remove('animating-out');
        overlay.classList.add('hidden');
        if (typeof clearSelection === 'function') clearSelection();
    }, 150);
}

// ── Tab navigation ───────────────────────────────────────────
function initNavigation() {
    document.querySelectorAll('.nav-item').forEach(item => {
        item.addEventListener('click', () => {
            console.log('[bl_admin] Tab clicked:', item.dataset.tab);
            document.querySelectorAll('.nav-item').forEach(i => i.classList.remove('active'));
            document.querySelectorAll('.tab').forEach(t => t.classList.add('hidden'));
            item.classList.add('active');
            const tab = item.dataset.tab;
            $('tab-'+tab).classList.remove('hidden');
            const [title, sub] = pageTitles[tab] || [tab, ''];
            $('page-title').textContent = title;
            $('page-sub').textContent   = sub;

            if (tab === 'staffmode') { sendToClient('getAllStaff'); renderSMPlayers(); }
            if (tab === 'permissions') { sendToClient('requestConfig'); sendToClient('getAllStaff'); }
            if (tab === 'logs') sendToClient('getLogs', { category: state.logCategory || 'all' });
            if (tab === 'sanctions') {
                sendToClient('requestSanctions');
                renderBans();
                renderWarns();
                renderJails();
                renderGhosts();
            }
            if (tab === 'vehicles') {
                const activePill = document.querySelector('#tab-vehicles .pill.active');
                if (activePill && activePill.dataset.vsub === 'customs') {
                    $('panel').classList.add('customs-mode');
                    if (typeof refreshCurrentVehicleMods === 'function') refreshCurrentVehicleMods();
                } else {
                    if (typeof renderVehicleCatalog === 'function') renderVehicleCatalog();
                }
            }
        });
    });

    window.refreshCurrentVehicleMods = () => {
        console.log('[bl_admin] Requesting vehicle mods...');
        sendToClient('getVehicleMods', {}, (mods) => {
            if (mods) {
                console.log('[bl_admin] Mods received:', mods.modEngine);
                window.state.currentVehicleMods = mods;
                if (typeof renderVehicleCustoms === 'function') {
                    renderVehicleCustoms();
                }
            } else {
                console.log('[bl_admin] No vehicle mods received.');
            }
        });
    };

    // Auto-refresh logs every 15s if tab is active
    setInterval(() => {
        const logsTab = $('tab-logs');
        if (logsTab && !logsTab.classList.contains('hidden')) {
            sendToClient('getLogs', state.logCategory || 'all');
        }
    }, 15000);

    // Session timer loop (1s)
    setInterval(() => {
        if (state.myDuty && typeof updateSMSessionTimer === 'function') {
            updateSMSessionTimer();
        }
    }, 1000);

    // sub-tabs (permissions)
    document.querySelectorAll('[data-psub]').forEach(p => {
        p.addEventListener('click', () => {
            document.querySelectorAll('[data-psub]').forEach(t => t.classList.remove('active'));
            document.querySelectorAll('.psub-content').forEach(c => c.classList.add('hidden'));
            p.classList.add('active');
            const sub = p.dataset.psub;
            $('psub-'+sub+'-content').classList.remove('hidden');
            
            if (sub === 'members') {
                $('perm-title').textContent = 'Membres du Staff';
                $('perm-sub-title').textContent = 'Gérez l\'équipe administrative (Online/Offline)';
                $('btn-save-perms').style.display = 'none';
                $('btn-add-staff').style.display = 'flex';
                sendToClient('getAllStaff');
            } else {
                $('perm-title').textContent = 'Gestion des Grades';
                $('perm-sub-title').textContent = 'Configurez les droits d\'accès en temps réel';
                $('btn-save-perms').style.display = 'flex';
                $('btn-add-staff').style.display = 'none';
            }
        });
    });
}

// ── Modal & Toast ─────────────────────────────────────────────
function openModal(title, content, onConfirm) {
    const modal = $('modal-action');
    $('modal-title').textContent = title;
    $('modal-body').innerHTML = content;
    modal.classList.remove('hidden');
    
    const confirmBtn = $('modal-confirm');
    const newBtn = confirmBtn.cloneNode(true);
    confirmBtn.parentNode.replaceChild(newBtn, confirmBtn);
    
    newBtn.addEventListener('click', () => {
        onConfirm();
        modal.classList.add('hidden');
    });
}

const hideModal = () => $('modal-action').classList.add('hidden');
window.closeModal = (id = 'modal-action') => {
    const m = $(id);
    if (m) m.classList.add('hidden');
};
$('modal-cancel')?.addEventListener('click', hideModal);
$('modal-cancel-btn')?.addEventListener('click', hideModal);

function selectGrade(grade) {
    state.selectedGrade = grade;
    $('perms-active-grade-title').textContent = grade.charAt(0).toUpperCase() + grade.slice(1);
    
    // Visibilité des boutons
    const delBtn = $('btn-delete-grade');
    const editBtn = $('btn-edit-grade-settings');
    const perms = state.config?.Permissions || {};
    const myLevel = (perms[state.myGrade] && perms[state.myGrade].level) || 0;
    const targetLevel = (perms[grade] && perms[grade].level) || 0;

    const canManage = (myLevel >= 100 && targetLevel < 100 && grade !== state.myGrade);
    const canEditSettings = (myLevel >= 100); // Un boss peut edit n'importe quel grade, y compris le sien
    
    if (delBtn) delBtn.style.display = canManage ? 'flex' : 'none';
    if (editBtn) editBtn.style.display = canEditSettings ? 'flex' : 'none';

    renderPermissions();
}

function renderPermissions() {
    const perms = state.config?.Permissions || {};
    const myLevel = (perms[state.myGrade] && perms[state.myGrade].level) || 0;

    // Auto-select the first grade if none selected
    if (!state.selectedGrade || !perms[state.selectedGrade]) {
        const sorted = Object.keys(perms).sort((a, b) => (perms[b].level || 0) - (perms[a].level || 0));
        state.selectedGrade = sorted[0] || null;
    }

    if (state.selectedGrade) {
        const gData = perms[state.selectedGrade] || {};
        const gColor = gData._color || 'var(--primary)';
        const gIcon  = gData._icon || '🛡️';
        const titleEl = $('perms-active-grade-title');
        if (titleEl) {
            titleEl.innerHTML = `
                <div class="grade-badge" style="color:${gColor}; border-color:${gColor}33; font-size:12px; padding:4px 12px">
                    <span style="margin-right:6px">${gIcon}</span>
                    ${state.selectedGrade.toUpperCase()}
                </div>
            `;
        }
    }
    // ── Sidebar : liste des grades ──
    const sidebar = $('perms-grades-list');
    if (sidebar) {
        sidebar.innerHTML = '';
        // Trier par level décroissant
        const sorted = Object.keys(perms).sort((a, b) => (perms[b].level || 0) - (perms[a].level || 0));
        sorted.forEach(g => {
            const gData = perms[g];
            const gradeLevel = gData.level || 0;
            const gradeColor = gData._color || 'var(--text2)';
            const gradeIcon  = gData._icon || '🛡️';
            const isLocked = gradeLevel >= myLevel && g !== state.myGrade;
            
            const btn = document.createElement('div');
            btn.className = 'perms-grade-item' + (g === state.selectedGrade ? ' active' : '');
            btn.style.borderLeft = `3px solid ${gradeColor}`;
            btn.innerHTML = `
                <div style="display:flex; align-items:center; gap:10px">
                    <span style="font-size:16px">${gData._icon || '🛡️'}</span>
                    <span style="color:${gradeColor}; font-weight:700">${g.charAt(0).toUpperCase() + g.slice(1)}</span>
                </div>
                <span style="font-size:10px;color:var(--muted)">Niv.${gradeLevel}${isLocked ? ' 🔒' : ''}</span>
            `;
            if (!isLocked || myLevel >= 100) {
                btn.onclick = () => selectGrade(g);
            } else {
                btn.style.opacity = '0.4';
                btn.style.cursor = 'not-allowed';
            }
            sidebar.appendChild(btn);
        });
    }

    // ── Contenu : toggles du grade sélectionné ──
    const grid = $('perms-toggles-grid');
    if (!grid || !state.selectedGrade) return;
    grid.innerHTML = '';

    const gradePerms = perms[state.selectedGrade] || {};
    const gradeLevel = gradePerms.level || 0;
    const canEdit = (myLevel >= 100) || (gradeLevel < myLevel);

    const search = ($('perm-search')?.value || '').toLowerCase();

    Object.entries(PERM_LABELS).forEach(([key, [label, desc]]) => {
        if (search !== '' && !label.toLowerCase().includes(search) && !desc.toLowerCase().includes(search) && !key.toLowerCase().includes(search)) return;
        
        const isOn = gradePerms[key] === true;
        const card = document.createElement('div');
        card.className = 'perm-card';
        card.innerHTML = `
            <div class="perm-card-info">
                <span class="perm-card-name">${label}</span>
                <span class="perm-card-desc">${desc}</span>
            </div>
            <label class="switch" title="${canEdit ? '' : 'Grade supérieur — lecture seule'}">
                <input type="checkbox" data-grade="${state.selectedGrade}" data-perm="${key}" ${isOn ? 'checked' : ''} ${canEdit ? '' : 'disabled'}>
                <span class="switch-track"><span class="switch-thumb"></span></span>
            </label>
        `;
        // Événement sur le toggle
        card.querySelector('input').addEventListener('change', function() {
            toggleGradePerm(this.dataset.grade, this.dataset.perm, this.checked);
        });
        grid.appendChild(card);
    });

    const fullBtn = $('btn-full-perms');
    if (fullBtn) {
        fullBtn.style.display = (state.selectedGrade && canEdit) ? 'flex' : 'none';
    }
}

function toggleGradePerm(grade, perm, value) {
    if (!state.config.Permissions[grade]) return;
    state.config.Permissions[grade][perm] = value;
    
    // Si on modifie son propre grade, on met à jour nos perms locales
    if (grade === state.myGrade) {
        state.myPerms = state.config.Permissions[grade];
        updateUIPermissions(state.myGrade);
    }

    // Optimisation : On ne veut pas que tout l'écran clignote quand ON change une perm
    state.isUpdatingLocalPerm = true; 
    sendToClient('updatePermissions', { grade, perm, value });
    setTimeout(() => { state.isUpdatingLocalPerm = false; }, 1000);
}

function updateUIPermissions(grade) {
    if (grade) state.myGrade = grade;
    
    // Si on a pas de perms en cache, on essaye de les récupérer du config
    if (Object.keys(state.myPerms || {}).length === 0 && state.config?.Permissions && state.myGrade) {
        state.myPerms = state.config.Permissions[state.myGrade] || {};
    }
    
    // Mettre à jour l'affichage du grade en bas à gauche
    if($('admin-grade') && state.myGrade) {
        const myData = state.config?.Permissions?.[state.myGrade] || {};
        const color = myData._color || 'var(--primary)';
        const icon  = myData._icon  || '🛡️';
        $('admin-grade').innerHTML = `
            <div class="sc-grade-badge" style="color:${color}; border-color:${color}33">
                <span>${icon}</span>
                ${state.myGrade.toUpperCase()}
            </div>
        `;
    }
    
    const perms = state.myPerms || {};
    const level = perms.level || 0;
    const isBoss = level >= 100;

    console.log('[BloodAdmin] Updating UI for Grade:', state.myGrade, 'Level:', level, 'Perms:', perms);

    const toggleTab = (tabName, condition) => {
        const tab = document.querySelector(`[data-tab="${tabName}"]`);
        if (tab) {
            if (condition) tab.classList.remove('hidden');
            else tab.classList.add('hidden');
        }
    };

    // Dashboard is available for all staff
    toggleTab('dashboard', level >= 30);

    // Permission-based visibility for Espace Staff (Staff Mode), Joueurs, Sanctions, and Reports
    toggleTab('staffmode', (perms['bl.noclip'] || perms['bl.esp'] || perms['bl.blips'] || perms['bl.staff'] || perms['bl.teleport'] || perms['bl.revive'] || perms['bl.heal']) === true);
    toggleTab('players', (perms['bl.spectate'] || perms['bl.warn'] || perms['bl.kick'] || perms['bl.freeze'] || perms['bl.jail'] || perms['bl.ban'] || perms['bl.noclip'] || perms['bl.teleport']) === true);
    toggleTab('sanctions', (perms['bl.ban'] || perms['bl.warn'] || perms['bl.jail'] || perms['bl.ghost'] || perms['bl.kick']) === true);
    toggleTab('reports', (perms['bl.warn'] || perms['bl.kick'] || perms['bl.spectate'] || perms['bl.freeze'] || perms['bl.jail'] || perms['bl.ban']) === true);
    toggleTab('staff', perms['bl.staff'] === true);

    // Specific permissions
    toggleTab('logs', perms['bl.logs'] === true);
    toggleTab('tools', (perms['bl.noclip'] || perms['bl.teleport'] || perms['bl.revive'] || perms['bl.heal'] || perms['bl.freeze']) === true);
    toggleTab('vehicles', (perms['bl.spawnveh'] || perms['bl.delveh']) === true);
    toggleTab('permissions', perms['bl.staff'] === true);
    toggleTab('economy', (perms['bl.money'] || perms['bl.item'] || perms['bl.job']) === true);
    toggleTab('resources', perms['bl.resources'] === true);
    toggleTab('anticheat', perms['bl.anticheat'] === true);
    toggleTab('console', level >= 85);
    toggleTab('world', perms['bl.world'] === true);

    // Redirect if the active tab has just been hidden in real-time
    const activeTabItem = document.querySelector('.nav-item.active');
    if (activeTabItem && activeTabItem.classList.contains('hidden')) {
        const dashNav = document.querySelector('.nav-item[data-tab="dashboard"]');
        if (dashNav) dashNav.click();
    }
    
    // Give Vehicle button visibility
    const giveBtn = document.querySelector('.v-give-btn-top');
    if (giveBtn) {
        if (perms['bl.giveveh']) giveBtn.classList.remove('hidden');
        else giveBtn.classList.add('hidden');
    }

    // Clear Logs Button visibility
    const clBtn = $('btn-clear-logs');
    if (clBtn) {
        if (isBoss) clBtn.classList.remove('hidden');
        else clBtn.classList.add('hidden');
    }

    // Reports Widget Visibility (HUD)
    const rw = $('reports-widget');
    if (rw) {
        if (perms['bl.staff'] && state.reports?.length > 0) rw.classList.remove('hidden');
        else rw.classList.add('hidden');
    }

    // Save Custom Vehicle Catalog Button
    const saveCustomBtn = $('btn-save-custom-veh');
    if (saveCustomBtn) {
        if (perms['bl.customcatalog'] || isBoss) saveCustomBtn.style.display = 'flex';
        else saveCustomBtn.style.display = 'none';
    }

    // Offline players features security
    const offPill = $('btn-players-offline');
    const offMetric = $('metric-registered-offline');
    const hasOfflineMod = perms['bl.offlinemod'] === true || isBoss;
    
    if (offPill) {
        if (hasOfflineMod) offPill.style.display = 'block';
        else offPill.style.display = 'none';
    }
    if (offMetric) {
        if (hasOfflineMod) offMetric.style.display = 'flex';
        else offMetric.style.display = 'none';
    }

    // Force real-time reset if player is currently viewing offline list but lost permission
    if (!hasOfflineMod && state.playersFilter === 'offline') {
        state.playersFilter = 'online';
        const onPill = $('btn-players-online');
        if (onPill) onPill.classList.add('active');
        if (offPill) offPill.classList.remove('active');
        
        // Hide offline action panel if it was open for an offline player
        const actionPanel = $('player-actions');
        if (actionPanel) actionPanel.classList.add('hidden');
        
        // Instant re-render of players list
        if (typeof renderPlayers === 'function') {
            renderPlayers();
        }
    }

    // Refresh selected player actions and identifiers panel if open to instantly reflect changed permissions (like bl.viewip)
    if (state.selectedPlayer && typeof renderPlayerActions === 'function') {
        const actionPanel = $('player-actions');
        if (actionPanel && !actionPanel.classList.contains('hidden')) {
            renderPlayerActions(state.selectedPlayer);
        }
    }
}



// ── Helpers ───────────────────────────────────────────────────
function updateDashStats() {
    if ($('dc-online')) $('dc-online').textContent = state.players.length;
    if ($('topbar-online')) $('topbar-online').textContent = state.players.length;
    // Reports & Staff (New cards)
    const activeReports = state.reports?.length || 0;
    if ($('dc-reports-active')) $('dc-reports-active').textContent = activeReports;
    if ($('dc-reports-total'))  $('dc-reports-total').textContent = state.totalReports || activeReports;
    if ($('dc-staff-online'))   $('dc-staff-online').textContent = state.staffInService || 0;
    if ($('dc-bans'))           $('dc-bans').textContent = state.bans ? state.bans.length : 0;
    if ($('dc-new-players'))    $('dc-new-players').textContent = state.newPlayersToday || 0;
    if ($('dc-res-count'))      $('dc-res-count').textContent = state.allResources ? state.allResources.length : 0;
    
    // Sanctions Tab Badges
    if ($('badge-bans'))        $('badge-bans').textContent = state.bans ? state.bans.length : 0;
    if ($('badge-warns'))       $('badge-warns').textContent = state.warns ? state.warns.length : 0;

    // Staff Mode Stats (New IDs)
    if ($('sm-staff-online-v3')) $('sm-staff-online-v3').textContent = state.staffInService || 0;
    if ($('sm-reports-count-v3')) $('sm-reports-count-v3').textContent = activeReports;
    if ($('sm-my-actions')) $('sm-my-actions').textContent = state.myActions || 0;

    // Render Dashboard Activity Feed
    if (typeof renderDashActivity === 'function') renderDashActivity();
}

function syncDutyUI() {
    const sw = $('sw-staff-service-v3');
    const banner = $('sm-duty-banner');
    const statusText = $('sm-status-text');
    
    if (sw) sw.checked = state.myDuty;
    if (banner) {
        if (state.myDuty) banner.classList.add('active');
        else banner.classList.remove('active');
    }
    if (statusText) {
        statusText.textContent = state.myDuty ? 'EN SERVICE' : 'HORS SERVICE';
        if (state.myDuty) statusText.classList.add('active');
        else statusText.classList.remove('active');
    }

    // Sidebar Indicator
    const agIndicator = $('ag-duty-indicator');
    const agText = $('ag-duty-text');
    if (agIndicator) {
        if (state.myDuty) agIndicator.classList.add('active');
        else agIndicator.classList.remove('active');
    }
    if (agText) {
        agText.textContent = state.myDuty ? 'EN SERVICE' : 'HORS SERVICE';
    }

    // Update tool buttons visual state
    if (!state.myDuty) {
        document.querySelectorAll('.sm-btn.active').forEach(b => b.classList.remove('active'));
    }
}

function initStaffMode() {
    const swDuty = $('sw-staff-service-v3');
    if (swDuty) {
        swDuty.checked = state.myDuty;
        // Listener is now handled in the main DOMContentLoaded block for consistency
    }

    // Quick Chat Send
    const chatBtn = $('btn-sm-chat-send');
    const chatInput = $('sm-chat-input-quick');
    if (chatBtn && chatInput) {
        chatBtn.onclick = () => {
            const val = chatInput.value.trim();
            if (val !== '') {
                sendToClient('sendStaffMessage', { message: val, channel: 'staffmode' });
                chatInput.value = '';
            }
        };
        chatInput.onkeydown = (e) => { if (e.key === 'Enter') chatBtn.click(); };
    }

    // Refresh Reports
    if ($('btn-refresh-reports-v4')) {
        $('btn-refresh-reports-v4').onclick = () => sendToClient('requestReports');
    }

    // Tool Buttons
    const tools = [
        { id: 'sm-tool-noclip', action: 'noclip' },
        { id: 'sm-tool-god', action: 'godmode' },
        { id: 'sm-tool-vanish', action: 'vanish' },
        { id: 'sm-tool-delgun', action: 'delgun' },
        { id: 'sm-tool-esp', action: 'esp' },
        { id: 'sm-tool-blips', action: 'blips' }
    ];

    tools.forEach(t => {
        const btn = $(t.id);
        if (btn) {
            btn.onclick = () => {
                if (!checkDuty()) return;
                btn.classList.toggle('active');
                sendToClient(t.action, { active: btn.classList.contains('active') });
                updateStaffHUD();
            };
        }
    });

    // One-shot buttons
    const tpBtn = $('sm-tool-tpmarker');
    if (tpBtn) {
        tpBtn.onclick = () => {
            if (!checkDuty()) return;
            sendToClient('tpmarker');
        };
    }

    const healBtn = $('sm-tool-heal');
    if (healBtn) {
        healBtn.onclick = () => {
            if (!checkDuty()) return;
            sendToClient('heal', { id: 0 }); // 0 = self
        };
    }

    const reviveBtn = $('sm-tool-revive');
    if (reviveBtn) {
        reviveBtn.onclick = () => {
            if (!checkDuty()) return;
            sendToClient('revive', { id: 0 }); // 0 = self
        };
    }

    const armorBtn = $('sm-tool-armor');
    if (armorBtn) {
        armorBtn.onclick = () => {
            if (!checkDuty()) return;
            sendToClient('armor', { id: 0 }); // 0 = self
        };
    }

    const fixBtn = $('sm-tool-fixworld');
    if (fixBtn) {
        fixBtn.onclick = () => {
            if (!checkDuty()) return;
            sendToClient('fixWorld');
        };
    }

    // One-shot buttons (Reports)
    if ($('btn-refresh-reports-main')) {
        $('btn-refresh-reports-main').onclick = () => sendToClient('requestReports');
    }

    const clearChatBtn = $('sm-tool-clearchat');
    if (clearChatBtn) {
        clearChatBtn.onclick = () => {
            if (!checkDuty()) return;
            sendToClient('globalAction', { action: 'clearchat' });
        };
    }

    if ($('btn-refresh-reports')) {
        $('btn-refresh-reports').onclick = () => sendToClient('requestReports');
    }

    const spawnBtn = $('btn-spawn-veh');
    const vehInput = $('veh-model');
    if (spawnBtn && vehInput) {
        spawnBtn.onclick = () => {
            if (!checkDuty()) return;
            const model = vehInput.value.trim();
            if (model !== '') {
                sendToClient('spawnVehicle', { model: model });
            }
        };
        vehInput.onkeydown = (e) => { if (e.key === 'Enter') spawnBtn.click(); };
        vehInput.oninput = (e) => {
            if (typeof updateVehiclePreview === 'function') {
                updateVehiclePreview(e.target.value);
            }
        };
    }

    syncDutyUI();
    updateStaffHUD();
    if (typeof renderSMReportsV4 === 'function') renderSMReportsV4();
    if (typeof renderSMChatPreview === 'function') renderSMChatPreview();
}

function updateStaffHUD() {
    const hud = $('staff-hud');
    if (!hud) return;

    const noclipActive = $('sm-tool-noclip')?.classList.contains('active');
    const delgunActive = $('sm-tool-delgun')?.classList.contains('active');

    if (noclipActive) $('hud-noclip').classList.add('active');
    else $('hud-noclip').classList.remove('active');

    if (delgunActive) $('hud-delgun').classList.add('active');
    else $('hud-delgun').classList.remove('active');

    if (noclipActive || delgunActive) hud.classList.remove('hidden');
    else hud.classList.add('hidden');

    // Sync Vanish button in HUD
    const vanishBtn = $('hqa-vanish');
    if (vanishBtn) {
        if ($('sm-tool-vanish')?.classList.contains('active')) vanishBtn.classList.add('active');
        else vanishBtn.classList.remove('active');
    }
}

function toggleHUDVanish() {
    if (!checkDuty()) return;
    const isVanishActive = $('sm-tool-vanish')?.classList.contains('active');
    sendToClient('vanish', { active: !isVanishActive });
}

// PRU Buttons
if ($('btn-pru-cancel')) {
    $('btn-pru-cancel').onclick = () => {
        $('player-report-ui').classList.add('hidden');
        sendToClient('closeReport');
    };
}

if ($('btn-pru-send')) {
    $('btn-pru-send').addEventListener('click', () => {
        const reason = $('pru-reason').value;
        if (reason.length < 5) {
            showToast('Veuillez décrire votre problème plus précisément', 'error');
            return;
        }
        sendToClient('submitReport', { 
            reason: reason, 
            coords: state.myCoords,
            voice: state.pendingVoice 
        });
        $('player-report-ui').classList.add('hidden');
        state.ignoreNextReportToast = true;
        showToast('Votre report a été envoyé avec succès !', 'success');
        sendToClient('closeReport');
        state.pendingVoice = null; // Reset
    });
}

if ($('pru-voice-toggle')) {
    $('pru-voice-toggle').onclick = () => {
        if (state.isRecordingVoice) stopVoiceRecording();
        else startVoiceRecording();
    };
}

function handleReportAction(id, action) {
    if (!checkDuty()) return;
    sendToClient('reportAction', { id: id, action: action });
}

function renderSMPlayers() {
    const tbody = $('sm-player-tbody'); if(!tbody) return;
    const search = ($('sm-player-search')?.value || '').toLowerCase();
    tbody.innerHTML = '';

    const filtered = state.players.filter(p => p.name.toLowerCase().includes(search) || p.id.toString().includes(search));
    
    if (filtered.length === 0) {
        tbody.innerHTML = '<tr><td colspan="3" style="text-align:center;padding:40px;color:var(--muted)">Aucun joueur trouvé</td></tr>';
        return;
    }

    filtered.forEach(p => {
        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td><span class="mono" style="color:var(--red2)">#${p.id}</span></td>
            <td>
                <div style="display:flex;flex-direction:column">
                    <div class="res-name-text">${esc(p.name)}</div>
                    <div style="font-size:10px;color:var(--muted)">Ping: ${p.ping}ms</div>
                </div>
            </td>
            <td>
                <div class="sm-direct-actions" style="justify-content:flex-end">
                    <button class="sm-action-btn-mini btn-sm-goto" title="Aller sur lui">Go To</button>
                    <button class="sm-action-btn-mini btn-sm-bring" title="Le ramener">Bring</button>
                    <button class="sm-action-btn-mini btn-sm-spec" title="Observer">Spectate</button>
                    <button class="sm-action-btn-mini btn-sm-warn warn" title="Avertir">Warn</button>
                    <button class="sm-action-btn-mini btn-sm-revive success">Heal/Revive</button>
                    <button class="sm-action-btn-mini btn-sm-kick danger">Kick</button>
                    <button class="sm-action-btn-mini btn-sm-ban danger">Ban</button>
                </div>
            </td>
        `;

        // Attach events
        tr.querySelector('.btn-sm-goto').onclick = () => sendToClient('teleport', {id: p.id});
        tr.querySelector('.btn-sm-bring').onclick = () => sendToClient('teleportToMe', {id: p.id});
        tr.querySelector('.btn-sm-spec').onclick = (e) => {
            const btn = e.currentTarget;
            btn.classList.toggle('active');
            sendToClient('spectate', {id: p.id, active: btn.classList.contains('active')});
        };
        tr.querySelector('.btn-sm-warn').onclick = () => quickWarn(p);
        tr.querySelector('.btn-sm-revive').onclick = () => sendToClient('revive', {id: p.id});
        tr.querySelector('.btn-sm-kick').onclick = () => quickKick(p);
        tr.querySelector('.btn-sm-ban').onclick = () => quickBan(p);

        tbody.appendChild(tr);
    });
}

function quickWarn(p) {
    openModal('Avertir ' + p.name, '<input type="text" id="w-reason" placeholder="Raison de l\'avertissement..."/>', () => {
        const reason = $('w-reason').value;
        sendToClient('warn', {id: p.id, reason});
        showToast(`Avertissement envoyé à ${p.name}`, 'info');
    });
}

function handleResourceAction(name, action) {
    if (action === 'copy') {
        const el = document.createElement('textarea');
        el.value = name;
        document.body.appendChild(el);
        el.select();
        document.execCommand('copy');
        document.body.removeChild(el);
        showToast('Nom copié : ' + name, 'success');
        return;
    }
    sendToClient('resourceAction', {name, action});
    showToast(`Ressource ${name} : ${action.toUpperCase()}`, 'info');
}

function changeStaffGrade(identifier, currentGrade) {
    openModal('Changer le grade', `
        <div class="m-field"><label>Nouveau Grade</label><select id="csg-grade">${Object.keys(state.config.Permissions || {}).map(g=>`<option value="${g}" ${g===currentGrade?'selected':''}>${g}</option>`).join('')}</select></div>
    `, () => {
        const grade = $('csg-grade').value;
        sendToClient('setStaffGrade', {identifier, grade});
        showToast(`Grade mis à jour : ${grade.toUpperCase()}`, 'success');
    });
}

function removeStaff(identifier, name) {
    openModal('Destituer ' + name, '<p>Êtes-vous sûr de vouloir retirer les droits admin de ce membre ?</p>', () => {
        sendToClient('setStaffGrade', {identifier, grade: 'user'});
        showToast(`Staff destitué : ${name}`, 'warning');
    });
}

function handleMetrics(d) {
    const m = d.metrics;
    if ($('ping-val')) $('ping-val').textContent = (m.ping || 0) + 'ms';
    if ($('mem-val')) $('mem-val').textContent = (m.serverMem || 0) + 'MB';
    if ($('dc-online')) $('dc-online').textContent = m.totalPlayers;
    if ($('topbar-online')) $('topbar-online').textContent = m.totalPlayers;

    // Health bars
    if ($('health-mem-pct')) {
        const memPct = Math.round((m.serverMem / 16384) * 100); // Assuming 16GB total for visualization
        $('health-mem-pct').textContent = memPct + '%';
        if ($('bar-mem')) $('bar-mem').style.width = memPct + '%';
    }
    if ($('qi-uptime')) $('qi-uptime').textContent = m.uptime || '0h 0m';
}

function selectPlayer(p) {
    const wasSelected = state.selectedPlayer && (
        (p.isOffline && state.selectedPlayer.isOffline && state.selectedPlayer.identifier === p.identifier) ||
        (!p.isOffline && !state.selectedPlayer.isOffline && state.selectedPlayer.id === p.id)
    );
    if (wasSelected) { clearSelection(); return; }
    state.selectedPlayer = p;
    renderPlayers();
    $('pa-name').textContent = p.name;
    
    const initials = p.name ? p.name.split(' ').map(n => n[0]).join('').substring(0, 2).toUpperCase() : '?';
    if ($('pa-avatar')) {
        $('pa-avatar').textContent = initials;
        if (p.isOffline) {
            $('pa-avatar').className = 'ap-avatar offline';
        } else {
            $('pa-avatar').className = 'ap-avatar online';
        }
    }

    if (p.isOffline) {
        $('pa-id').textContent   = `Hors-ligne · Identifier: ${p.identifier.substring(0, 16)}...`;
    } else {
        $('pa-id').textContent   = `ID: #${p.id} · Ping: ${p.ping}ms`;
    }

    // Render Identifiers with Copy button
    const idContainer = $('player-identifiers-container');
    if (idContainer) {
        idContainer.innerHTML = '';
        
        let idList = [];
        if (p.isOffline) {
            const label = p.identifier.startsWith('steam:') ? 'Steam Hex' : (p.identifier.startsWith('license:') ? 'License' : 'Identifier');
            idList.push({ label: label, value: p.identifier, icon: '🔑' });
        } else {
            const ids = p.identifiers || {};
            const hasViewIP = state.myPerms?.['bl.viewip'] === true || (state.config?.Permissions?.[state.myGrade]?.level || 0) >= 100;
            if (ids.steam) idList.push({ label: 'Steam Hex', value: ids.steam, icon: '🎮' });
            if (ids.license) idList.push({ label: 'License', value: ids.license, icon: '🔑' });
            if (ids.discord) idList.push({ label: 'Discord', value: ids.discord, icon: '💬' });
            if (ids.ip && hasViewIP) idList.push({ label: 'Adresse IP', value: ids.ip, icon: '🌐' });
        }
        
        if (idList.length > 0) {
            idList.forEach(item => {
                const row = document.createElement('div');
                row.className = 'ap-id-row';
                row.innerHTML = `
                    <div class="ap-id-left">
                        <span class="ap-id-icon">${item.icon}</span>
                        <div class="ap-id-info">
                            <span class="ap-id-label">${item.label}</span>
                            <span class="ap-id-val" title="${item.value}">${item.value}</span>
                        </div>
                    </div>
                    <button class="ap-id-copy-btn" title="Copier l'identifiant">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><rect x="9" y="9" width="13" height="13" rx="2" ry="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg>
                    </button>
                `;
                
                row.querySelector('.ap-id-copy-btn').onclick = (e) => {
                    e.stopPropagation();
                    copyToClipboard(item.value);
                };
                
                idContainer.appendChild(row);
            });
        } else {
            idContainer.innerHTML = `<div class="empty-state" style="padding:10px 0;">Aucun identifiant disponible</div>`;
        }
    }

    buildActions();
    $('player-actions').classList.remove('hidden');
}

function selectPlayerById(id) {
    const p = state.players.find(x => x.id === id);
    if (p) {
        document.querySelector('[data-tab="players"]').click();
        setTimeout(() => selectPlayer(p), 100);
    }
}

function clearSelection() {
    state.selectedPlayer = null;
    $('player-actions').classList.add('hidden');
    renderPlayers();
}

// ── Action buttons logic ──────────────────────────────────────
function buildActions() {
    const g = $('actions-grid'); if (!g) return;
    g.innerHTML = '';
    
    if (!state.selectedPlayer) return;
    
    const isOffline = state.selectedPlayer.isOffline === true;
    
    if (isOffline) {
        const groupContainer = document.createElement('div');
        groupContainer.className = 'ap-group';
        groupContainer.innerHTML = `<div class="ap-group-title">🛡️ Modération Hors-ligne</div>`;
        const subGrid = document.createElement('div');
        subGrid.className = 'ap-group-grid';
        
        const actions = [
            {label: 'Warn', cls: 'warn', icon: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>', fn: () => quickOfflineWarn(state.selectedPlayer)},
            {label: 'Ban', cls: 'danger', icon: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>', fn: () => quickOfflineBan(state.selectedPlayer)},
            {label: 'Grade / Perms', cls: 'primary-btn', icon: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>', fn: () => quickOfflinePromote(state.selectedPlayer)}
        ];
        
        actions.forEach(a => {
            const btn = document.createElement('button');
            btn.className = 'ap-btn ' + a.cls;
            btn.innerHTML = `${a.icon}<span>${a.label}</span>`;
            btn.onclick = a.fn;
            subGrid.appendChild(btn);
        });
        groupContainer.appendChild(subGrid);
        g.appendChild(groupContainer);
    } else {
        const groups = [
            {
                title: '⚡ Actions Directes',
                actions: [
                    {label: 'Spectate', cls: 'primary-btn', icon: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>', fn: (e) => {
                        const btn = e.currentTarget;
                        btn.classList.toggle('active');
                        sendToClient('spectate', {id: state.selectedPlayer.id, active: btn.classList.contains('active')});
                    }},
                    {label: 'Revive', cls: 'success', icon: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M12 2v20M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>', fn: () => sendToClient('revive', {id: state.selectedPlayer.id})},
                    {label: 'Heal', cls: 'cyan-btn', icon: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M12 2v20M2 12h20"/></svg>', fn: () => sendToClient('heal', {id: state.selectedPlayer.id})},
                    {label: 'TP sur lui', cls: 'info-btn', icon: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="15 3 21 3 21 9"/><line x1="10" y1="14" x2="21" y2="3"/><polyline points="9 21 3 21 3 15"/><line x1="14" y1="10" x2="3" y2="21"/></svg>', fn: () => sendToClient('teleport', {id: state.selectedPlayer.id})},
                    {label: 'TP sur moi', cls: 'info-btn', icon: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="9 15 3 15 3 9"/><line x1="10" y1="14" x2="3" y2="21"/><polyline points="15 9 21 9 21 15"/><line x1="14" y1="10" x2="21" y2="3"/></svg>', fn: () => sendToClient('teleportToMe', {id: state.selectedPlayer.id})},
                    {label: 'Freeze', cls: 'warn', icon: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><rect x="3" y="3" width="18" height="18" rx="2" ry="2"/><line x1="9" y1="9" x2="15" y2="15"/><line x1="15" y1="9" x2="9" y2="15"/></svg>', fn: () => sendToClient('freeze', {id: state.selectedPlayer.id})}
                ]
            },
            {
                title: '🛡️ Sécurité & Modération',
                actions: [
                    {label: 'Warn', cls: 'warn', icon: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>', fn: () => quickOfflineWarn(state.selectedPlayer)},
                    {label: 'Jail', cls: 'amber', icon: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>', fn: () => quickJail(state.selectedPlayer)},
                    {label: 'Kick', cls: 'warn', icon: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>', fn: () => quickKick(state.selectedPlayer)},
                    {label: 'Ban Perm', cls: 'danger', icon: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>', fn: () => quickBan(state.selectedPlayer)},
                    {label: 'Ban Temp', cls: 'danger', icon: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>', fn: () => quickTempBan(state.selectedPlayer)},
                    {label: 'Ghost', cls: 'purple', icon: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M12 2a10 10 0 0 0-10 10c0 5.25 10 10 10 10s10-4.75 10-10A10 10 0 0 0 12 2zm0 14a4 4 0 1 1 0-8 4 4 0 0 1 0 8z"/></svg>', fn: () => sendToClient('ghostBan', state.selectedPlayer.id)}
                ]
            },
            {
                title: '💼 Gestion In-game',
                actions: [
                    {label: 'Set Job', cls: 'primary-btn', icon: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><rect x="2" y="7" width="20" height="14" rx="2" ry="2"/><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/></svg>', fn: () => quickSetJob(state.selectedPlayer)},
                    {label: 'Give Money', cls: 'success', icon: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="12" y1="12" x2="12" y2="12.01"/><path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z"/></svg>', fn: () => quickGiveMoney(state.selectedPlayer)},
                    {label: 'Clear Inv', cls: 'danger', icon: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/><line x1="10" y1="11" x2="10" y2="17"/><line x1="14" y1="11" x2="14" y2="17"/></svg>', fn: () => sendToClient('clearInventory', {id: state.selectedPlayer.id})}
                ]
            }
        ];
        
        groups.forEach(group => {
            const groupContainer = document.createElement('div');
            groupContainer.className = 'ap-group';
            groupContainer.innerHTML = `<div class="ap-group-title">${group.title}</div>`;
            const subGrid = document.createElement('div');
            subGrid.className = 'ap-group-grid';
            
            group.actions.forEach(a => {
                const btn = document.createElement('button');
                btn.className = 'ap-btn ' + a.cls;
                btn.innerHTML = `${a.icon}<span>${a.label}</span>`;
                btn.onclick = a.fn;
                subGrid.appendChild(btn);
            });
            groupContainer.appendChild(subGrid);
            g.appendChild(groupContainer);
        });
    }
}

function quickMessage(p, nameIfRaw) {
    const id = typeof p === 'object' ? p.id : p;
    const name = typeof p === 'object' ? p.name : nameIfRaw;
    
    openModal('Message à ' + name, '<input type="text" id="m-text" placeholder="Message..." style="width:100%; border:1px solid var(--border2); padding:10px; border-radius:8px; background:var(--bg3); color:#fff; outline:none;"/>', () => {
        const msg = $('m-text').value;
        if (msg) {
            sendToClient('sendMessage', {id: id, message: msg});
            showToast('Message envoyé à ' + name, 'success');
        }
    });
}

function quickSetJob(p) {
    openModal('Set Job: ' + p.name, `
        <div class="m-field"><label>Nom du Job</label><input type="text" id="sj-job" placeholder="police"/></div>
        <div class="m-field"><label>Grade (ID)</label><input type="number" id="sj-grade" placeholder="0"/></div>
    `, () => {
        sendToClient('setJob', {id: p.id, job: $('sj-job').value, grade: parseInt($('sj-grade').value)});
    });
}

function quickGiveMoney(p) {
    openModal('Give Money: ' + p.name, `
        <div class="m-field"><label>Compte</label><select id="gm-account"><option value="money">Cash</option><option value="bank">Banque</option><option value="black_money">Sale</option></select></div>
        <div class="m-field"><label>Montant</label><input type="number" id="gm-amount" placeholder="1000"/></div>
    `, () => {
        sendToClient('giveMoney', {id: p.id, account: $('gm-account').value, amount: parseInt($('gm-amount').value)});
    });
}

function quickKick(p) {
    openModal('Kick ' + p.name, '<input type="text" id="k-reason" placeholder="Raison..."/>', () => {
        const reason = $('k-reason').value;
        sendToClient('kick', {id: p.id, reason});
        showToast(`${p.name} a été expulsé`, 'warning');
    });
}

function quickBan(p) {
    openModal('Ban ' + p.name, '<input type="text" id="b-reason" placeholder="Raison..."/>', () => {
        const reason = $('b-reason').value;
        sendToClient('ban', {id: p.id, reason, duration: 0});
        showToast(`${p.name} a été banni`, 'error');
    });
}

function quickOfflineWarn(p) {
    if (!checkDuty()) return;
    openModal('Avertissement Hors-ligne: ' + p.name, `
        <div style="display:flex; flex-direction:column; gap:12px;">
            <p style="font-size:12px; color:var(--muted2); word-break:break-all;">Identifier: <code>${p.identifier}</code></p>
            <input type="text" id="ow-reason" placeholder="Raison de l'avertissement..." style="width:100%; border:1px solid var(--border2); padding:10px; border-radius:8px; background:var(--bg3); color:#fff; outline:none;" />
        </div>
    `, () => {
        const reason = $('ow-reason').value.trim() || 'Avertissement rapide';
        sendToClient('warnOfflinePlayer', {
            identifier: p.identifier,
            playerName: p.name,
            reason: reason
        });
        showToast(`Avertissement envoyé à ${p.name} (Hors-ligne)`, 'warning');
    });
}

function quickOfflineBan(p) {
    if (!checkDuty()) return;
    openModal('Bannissement Hors-ligne: ' + p.name, `
        <div style="display:flex; flex-direction:column; gap:12px;">
            <p style="font-size:12px; color:var(--muted2); word-break:break-all;">Identifier: <code>${p.identifier}</code></p>
            <input type="text" id="ob-reason" placeholder="Raison du bannissement..." style="width:100%; border:1px solid var(--border2); padding:10px; border-radius:8px; background:var(--bg3); color:#fff; outline:none;" />
            <select id="ob-duration" style="width:100%; height:38px; background:var(--bg3); color:white; border:1px solid var(--border2); border-radius:8px; padding:0 10px; outline:none;">
                <option value="0">Permanent</option>
                <option value="3600">1 Heure</option>
                <option value="86400">1 Jour</option>
                <option value="604800">1 Semaine</option>
                <option value="2592000">30 Jours</option>
            </select>
        </div>
    `, () => {
        const reason = $('ob-reason').value.trim() || 'Bannissement rapide';
        const duration = parseInt($('ob-duration').value);
        sendToClient('banOfflinePlayer', {
            identifier: p.identifier,
            playerName: p.name,
            reason: reason,
            duration: duration
        });
        showToast(`${p.name} (Hors-ligne) a été banni`, 'error');
    });
}

function quickOfflinePromote(p) {
    if (!checkDuty()) return;
    
    const perms = state.config?.Permissions || {};
    let optionsHtml = '';
    
    Object.keys(perms).forEach(grade => {
        const selected = grade === p.grade ? 'selected' : '';
        optionsHtml += `<option value="${grade}" ${selected}>${grade.toUpperCase()}</option>`;
    });
    
    if (!perms['user']) {
        const selected = p.grade === 'user' ? 'selected' : '';
        optionsHtml += `<option value="user" ${selected}>USER</option>`;
    }
    
    openModal('Modifier le Grade: ' + p.name, `
        <div style="display:flex; flex-direction:column; gap:12px;">
            <p style="font-size:12px; color:var(--muted2); word-break:break-all;">Identifier: <code>${p.identifier}</code></p>
            <p style="font-size:12px; color:var(--text)">Grade actuel : <span style="font-weight:700; color:var(--red);">${p.grade.toUpperCase()}</span></p>
            <select id="op-grade" style="width:100%; height:38px; background:var(--bg3); color:white; border:1px solid var(--border2); border-radius:8px; padding:0 10px; outline:none;">
                ${optionsHtml}
            </select>
        </div>
    `, () => {
        const newGrade = $('op-grade').value;
        if (newGrade === p.grade) {
            showToast('Aucun changement de grade', 'info');
            return;
        }
        
        sendToClient('setStaffGrade', {
            identifier: p.identifier,
            grade: newGrade
        });
        
        p.grade = newGrade;
        showToast(`Grade de ${p.name} mis à jour en : ${newGrade.toUpperCase()}`, 'success');
        
        setTimeout(() => {
            sendToClient('requestOfflinePlayers');
        }, 300);
    });
}

function updatePerm(grade, key, val) {
    state.config.Permissions[grade][key] = val;
}

// Initializers
document.addEventListener('DOMContentLoaded', () => {
    console.log('[bl_admin] DOM Content Loaded, initializing...');
    
    // 1. Close menu (Prioritized & Robust)
    const closeFunc = () => {
        console.log('[bl_admin] Closing menu requested...');
        
        // Always force-hide any active modals/popups when the menu closes to prevent visual glitches
        $('modal-action')?.classList.add('hidden');
        $('modal-tpzones')?.classList.add('hidden');
        
        if (!$('player-report-ui').classList.contains('hidden')) {
            $('player-report-ui').classList.add('hidden');
            sendToClient('closeReport');
        } else {
            sendToClient('close');
        }
    };

    $('btn-close')?.addEventListener('click', closeFunc);
    window.addEventListener('keydown', e => {
        if (e.key === 'Escape') {
            const modalAction = $('modal-action');
            const modalTpZones = $('modal-tpzones');
            let modalClosed = false;

            // If the primary action/sanction modal is open, close it first
            if (modalAction && !modalAction.classList.contains('hidden')) {
                modalAction.classList.add('hidden');
                modalClosed = true;
            }

            // If the teleport zones modal is open, close it first
            if (modalTpZones && !modalTpZones.classList.contains('hidden')) {
                modalTpZones.classList.add('hidden');
                modalClosed = true;
            }

            // If we closed a modal, intercept the keypress to keep the admin menu open
            if (modalClosed) {
                e.preventDefault();
                e.stopPropagation();
                return;
            }

            // If no modal was open, close the main menu normally
            closeFunc();
        }
    });

    initNavigation();
    $('player-search')?.addEventListener('input', renderPlayers);

    // Players Online / Offline Toggle Filter & Refresh Button
    $('btn-players-online')?.addEventListener('click', () => {
        state.playersFilter = 'online';
        $('btn-players-online').classList.add('active');
        $('btn-players-offline').classList.remove('active');
        renderPlayers();
    });

    $('btn-players-offline')?.addEventListener('click', () => {
        state.playersFilter = 'offline';
        $('btn-players-offline').classList.add('active');
        $('btn-players-online').classList.remove('active');
        sendToClient('requestOfflinePlayers');
        renderPlayers();
    });

    $('btn-refresh')?.addEventListener('click', () => {
        if (state.playersFilter === 'offline') {
            sendToClient('requestOfflinePlayers');
            showToast('Actualisation des joueurs hors-ligne...', 'info');
        } else {
            sendToClient('requestPlayers');
            showToast('Actualisation des joueurs en ligne...', 'info');
        }
    });
    $('perm-search')?.addEventListener('input', () => {
        const q = $('perm-search').value.toLowerCase();
        document.querySelectorAll('.perm-toggle-row-v2').forEach(c => {
            c.style.display = c.textContent.toLowerCase().includes(q) ? 'flex' : 'none';
        });
    });
    
    // Resource listeners
    $('resource-search')?.addEventListener('input', renderResources);
    $('btn-refresh-res-list')?.addEventListener('click', () => sendToClient('requestResources'));

    // World & Vehicles V3
    $('btn-set-weather-v3')?.addEventListener('click', () => { if(!checkDuty()) return; const w=$('weather-select-v3').value; sendToClient('setWeather', {weather: w}); showToast('Météo: ' + w, 'info'); });
    $('btn-set-time-v3')?.addEventListener('click', () => { if(!checkDuty()) return; const t=parseInt($('time-slider-v3').value); sendToClient('setTime', {hour: t, minute: 0}); showToast('Heure: ' + t + ':00', 'info'); });
    $('time-slider-v3')?.addEventListener('input', () => { $('time-display-v3').textContent = $('time-slider-v3').value + ':00'; });
    $('btn-announce-v3')?.addEventListener('click', () => { if(!checkDuty()) return; const msg=$('announce-text-v3').value.trim(); if(msg) { sendToClient('serverAnnounce', msg); $('announce-text-v3').value = ''; showToast('Annonce envoyée', 'success'); } });
    
    // Toggles V3
    $('noclip-toggle-v3')?.addEventListener('change', (e) => { if(!checkDuty()) { e.target.checked = false; return; } sendToClient('noclip', {active: e.target.checked}); });
    $('godmode-toggle-v3')?.addEventListener('change', (e) => { if(!checkDuty()) { e.target.checked = false; return; } sendToClient('godmode', {active: e.target.checked}); });
    $('invis-toggle-v3')?.addEventListener('change', (e) => { if(!checkDuty()) { e.target.checked = false; return; } sendToClient('vanish', {active: e.target.checked}); });
    $('esp-toggle-v3')?.addEventListener('change', (e) => { if(!checkDuty()) { e.target.checked = false; return; } sendToClient('esp', {active: e.target.checked}); });
    $('blackout-toggle-v3')?.addEventListener('change', (e) => { if(!checkDuty()) { e.target.checked = false; return; } sendToClient('blackout', {active: e.target.checked}); });

    // Global Action Buttons V3
    $('btn-global-revive')?.addEventListener('click', () => { if(!checkDuty()) return; sendToClient('globalAction', {action: 'revive'}); showToast('Revive global lancé', 'success'); });
    $('btn-global-dv')?.addEventListener('click', () => { if(!checkDuty()) return; sendToClient('globalAction', {action: 'dv'}); showToast('Nettoyage véhicules global', 'warning'); });
    $('btn-global-kick')?.addEventListener('click', () => { 
        if(!checkDuty()) return; 
        openModal('Expulser tout le monde', '<p class="danger">Êtes-vous sûr de vouloir expulser TOUS les joueurs ?</p>', () => {
            sendToClient('globalAction', {action: 'kickall'});
        });
    });
    $('btn-clear-chat')?.addEventListener('click', () => { if(!checkDuty()) return; sendToClient('globalAction', {action: 'clearchat'}); showToast('Chat nettoyé', 'info'); });
    $('btn-wipe-peds')?.addEventListener('click', () => { if(!checkDuty()) return; sendToClient('globalAction', {action: 'wipepeds'}); showToast('Nettoyage NPCs...', 'info'); });
    $('btn-wipe-props')?.addEventListener('click', () => { if(!checkDuty()) return; sendToClient('globalAction', {action: 'wipeprops'}); showToast('Nettoyage Objets...', 'info'); });
    $('btn-fix-world')?.addEventListener('click', () => { if(!checkDuty()) return; sendToClient('globalAction', {action: 'fixworld'}); showToast('Monde stabilisé', 'success'); });

    $('btn-tp-coords')?.addEventListener('click', () => { const x=parseFloat($('tp-x').value), y=parseFloat($('tp-y').value), z=parseFloat($('tp-z').value); if(!isNaN(x) && !isNaN(y) && !isNaN(z)) { sendToClient('teleportCoords', {x,y,z}); showToast('TP Coords', 'info'); } });
    $('btn-refresh-perms-v2')?.addEventListener('click', () => { sendToClient('requestConfig'); showToast('Actualisation des grades...', 'info'); });

    // Add Grade button
    $('btn-add-grade')?.addEventListener('click', () => {
        openModal('Créer un nouveau grade', `
            <div class="m-field">
                <label>Nom du grade (ex: moderateur)</label>
                <input type="text" id="new-grade-name" class="econ-input" placeholder="moderateur" autocomplete="off"/>
            </div>
            <div style="display:grid; grid-template-columns: 1fr 1fr; gap: 15px">
                <div class="m-field">
                    <label>Niveau (1-99)</label>
                    <input type="number" id="new-grade-level" class="econ-input mono" value="30" min="1" max="99"/>
                </div>
                <div class="m-field">
                    <label>Couleur</label>
                    <input type="color" id="new-grade-color" class="econ-input" style="padding:2px; height:45px" value="#3b82f6"/>
                </div>
            </div>
            <div class="m-field">
                <label>Sélectionner une icône</label>
                <div style="display:grid; grid-template-columns: repeat(6, 1fr); gap: 10px; margin-top:10px">
                    ${['🛡️','🔨','🔵','⭐','🎭','🎯','👑','🔥','🔋','📦','💰','🧪','💎','⚡','🩸','👤','🚓','🔫','💊','🛠️','🚧','📡','🔋','🧬'].map(i => `<div class="icon-pick" onclick="this.parentNode.querySelectorAll('.icon-pick').forEach(e=>e.classList.remove('active')); this.classList.add('active')">${i}</div>`).join('')}
                </div>
            </div>
        `, () => {
            const name = $('new-grade-name')?.value?.trim().toLowerCase().replace(/\s+/g, '_');
            const level = parseInt($('new-grade-level')?.value) || 30;
            const color = $('new-grade-color')?.value || '#3b82f6';
            const icon  = document.querySelector('.icon-pick.active')?.textContent || '🛡️';

            if (!name) { showToast('Nom invalide', 'error'); return; }
            if (state.config?.Permissions?.[name]) { showToast('Ce grade existe déjà', 'error'); return; }
            sendToClient('addGrade', { name, level, color, icon });
        });
        // Active l'icone par défaut
        document.querySelector('.icon-pick')?.classList.add('active');
    });

    // Edit Grade settings
    $('btn-edit-grade-settings')?.addEventListener('click', () => {
        if (!state.selectedGrade) return;
        const gData = state.config.Permissions[state.selectedGrade];
        if (!gData) return;

        openModal(`Modifier le grade ${state.selectedGrade.toUpperCase()}`, `
            <div class="m-field">
                <label>Nom du grade (Attention: change l'identifiant)</label>
                <input type="text" id="edit-grade-name" class="econ-input" value="${state.selectedGrade}" autocomplete="off"/>
            </div>
            <div style="display:grid; grid-template-columns: 1fr 1fr; gap: 15px">
                <div class="m-field">
                    <label>Niveau (1-99)</label>
                    <input type="number" id="edit-grade-level" class="econ-input mono" value="${gData.level}" min="1" max="99"/>
                </div>
                <div class="m-field">
                    <label>Couleur</label>
                    <input type="color" id="edit-grade-color" class="econ-input" style="padding:2px; height:45px" value="${gData._color || '#3b82f6'}"/>
                </div>
            </div>
            <div class="m-field">
                <label>Sélectionner une icône</label>
                <div style="display:grid; grid-template-columns: repeat(6, 1fr); gap: 10px; margin-top:10px">
                    ${['🛡️','🔨','🔵','⭐','🎭','🎯','👑','🔥','🔋','📦','💰','🧪','💎','⚡','🩸','👤','🚓','🔫','💊','🛠️','🚧','📡','🔋','🧬'].map(i => `<div class="icon-pick ${gData._icon === i ? 'active' : ''}" onclick="this.parentNode.querySelectorAll('.icon-pick').forEach(e=>e.classList.remove('active')); this.classList.add('active')">${i}</div>`).join('')}
                </div>
            </div>
        `, () => {
            const oldName = state.selectedGrade;
            const newName = $('edit-grade-name')?.value?.trim().toLowerCase().replace(/\s+/g, '_');
            const level   = parseInt($('edit-grade-level')?.value) || 30;
            const color   = $('edit-grade-color')?.value || '#3b82f6';
            const icon    = document.querySelector('.icon-pick.active')?.textContent || '🛡️';

            if (!newName) { showToast('Nom invalide', 'error'); return; }
            sendToClient('updateGradeSettings', { oldName, newName, level, color, icon });
            state.selectedGrade = newName;
        });
    });

    // Delete Grade button
    $('btn-delete-grade')?.addEventListener('click', () => {
        if (!state.selectedGrade) return;
        if (state.selectedGrade === 'boss' || state.selectedGrade === state.myGrade) {
            showToast('Suppression impossible pour ce grade', 'error');
            return;
        }

        openModal(`Supprimer le grade ${state.selectedGrade.toUpperCase()} ?`, `
            <p style="color:var(--text2); font-size:13px">Attention, cette action est irréversible. Les membres ayant ce grade perdront leurs accès.</p>
        `, () => {
            sendToClient('deleteGrade', { name: state.selectedGrade });
            state.selectedGrade = null;
        });
    });

    // Permissions
    $('btn-full-perms')?.addEventListener('click', () => {
        if (!state.selectedGrade) return;

        openModal('Full Perm — Confirmation', `
            <p style="color:var(--text2); font-size:13px; text-align:center; line-height: 1.5;">
                Voulez-vous vraiment attribuer <strong style="color:var(--primary)">TOUTES</strong> les permissions au grade <strong style="text-transform: uppercase;">${state.selectedGrade}</strong> ?
            </p>
        `, () => {
            if (typeof PERM_LABELS !== 'undefined') {
                Object.keys(PERM_LABELS).forEach(p => {
                    state.config.Permissions[state.selectedGrade][p] = true;
                });
                
                if (state.selectedGrade === state.myGrade) {
                    state.myPerms = state.config.Permissions[state.selectedGrade];
                    updateUIPermissions(state.myGrade);
                }

                renderPermissions();
                
                // Save and broadcast
                const permsToSave = state.config.Permissions;
                sendToClient('savePermissionsSecure', permsToSave);
                showToast('Toutes les permissions ont été attribuées et sauvegardées !', 'success');
            }
        });
    });

    $('btn-save-perms').onclick = () => {
        const permsToSave = state.config.Permissions;
        console.log('[bl_admin] Saving permissions:', JSON.stringify(permsToSave));
        sendToClient('savePermissionsSecure', permsToSave);
    };

    $('btn-add-staff')?.addEventListener('click', () => {
        openModal('Recruter Staff', `
            <div class="m-field"><label>ID du joueur (en ligne)</label><input type="number" id="as-id" placeholder="Ex: 42"/></div>
            <div class="m-field"><label>Grade à attribuer</label><select id="as-grade">${Object.keys(state.config.Permissions || {}).map(g=>`<option value="${g}">${g.charAt(0).toUpperCase() + g.slice(1)}</option>`).join('')}</select></div>
        `, () => {
            const id = parseInt($('as-id').value);
            const grade = $('as-grade').value;
            if(!id) return showToast('ID invalide','error');
            sendToClient('addStaff', {id, grade});
            showToast('Demande envoyée','info');
        });
    });

    $('btn-refresh-staff-list')?.addEventListener('click', () => sendToClient('getAllStaff'));
    $('staff-member-search')?.addEventListener('input', renderStaffMembers);
    
    // Staff Mode Service Toggle (Synchronized with Dashboard & Sidebar)
    $('sw-staff-service-v3')?.addEventListener('change', e => {
        const active = e.target.checked;
        state.myDuty = active;
        if (active) state.dutyStartTime = Date.now();
        else state.dutyStartTime = null;

        sendToClient('toggleService', {active});
        syncDutyUI();
        showToast(active ? 'Prise de service active' : 'Fin de service', active ? 'success' : 'info');
    });

    $('btn-sm-refresh-players')?.addEventListener('click', () => {
        sendToClient('requestPlayers');
        showToast('Rafraîchissement des joueurs...', 'info');
    });

    $('sm-player-search')?.addEventListener('input', renderSMPlayers);

    $('btn-sm-noclip-v2')?.addEventListener('click', e => { 
        const btn = e.currentTarget; btn.classList.toggle('active'); 
        const active = btn.classList.contains('active');
        sendToClient('toggleTool', {tool: 'noclip', active});
        showToast(`Noclip : ${active ? 'ACTIF' : 'INACTIF'}`, 'info');
    });
    $('btn-sm-god-v2')?.addEventListener('click', e => { 
        const btn = e.currentTarget; btn.classList.toggle('active'); 
        const active = btn.classList.contains('active');
        sendToClient('toggleTool', {tool: 'godmode', active});
        showToast(`Godmode : ${active ? 'ACTIF' : 'INACTIF'}`, 'info');
    });
    $('btn-sm-inv-v2')?.addEventListener('click', e => { 
        const btn = e.currentTarget; btn.classList.toggle('active'); 
        const active = btn.classList.contains('active');
        sendToClient('toggleTool', {tool: 'invisible', active});
        showToast(`Invisibilité : ${active ? 'ACTIF' : 'INACTIF'}`, 'info');
    });
    $('btn-sm-names-v2')?.addEventListener('click', e => { 
        const btn = e.currentTarget; btn.classList.toggle('active'); 
        const active = btn.classList.contains('active');
        sendToClient('toggleTool', {tool: 'names', active});
        showToast(`Noms : ${active ? 'ACTIF' : 'INACTIF'}`, 'info');
    });

    $('btn-refresh-logs')?.addEventListener('click', () => {
        sendToClient('getLogs', { category: state.logCategory || 'all' });
        showToast('Logs rafraîchis', 'info');
    });

    document.querySelectorAll('[data-log-cat]').forEach(pill => {
        pill.addEventListener('click', () => {
            document.querySelectorAll('[data-log-cat]').forEach(p => p.classList.remove('active'));
            pill.classList.add('active');
            state.logCategory = pill.dataset.logCat;
            sendToClient('getLogs', { category: state.logCategory });
        });
    });

    $('btn-clear-logs')?.addEventListener('click', () => {
        openModal('Effacer les Logs', '<p>Êtes-vous sûr de vouloir supprimer <b>tous</b> les logs ?<br><small class="muted">Cette action est irréversible.</small></p>', () => {
            sendToClient('clearLogs');
        });
    });

    $('log-search')?.addEventListener('input', renderLogs);
    $('perm-search')?.addEventListener('input', renderPermissions);
    $('btn-refresh-perms-v2')?.addEventListener('click', () => {
        sendToClient('requestConfig');
        showToast('Rafraîchissement des grades...', 'info');
    });

    // Modal cancel
    $('modal-cancel-btn')?.addEventListener('click', hideModal);
    $('modal-cancel')?.addEventListener('click', hideModal);

    // Economy & Quick Actions (Economy tab)
    $('btn-give-money')?.addEventListener('click', () => { if(!checkDuty()) return; const id=parseInt($('econ-player-id').value), acc=$('econ-type').value, amt=parseInt($('econ-amount').value); if(id && amt) sendToClient('giveMoney', {id, account:acc, amount:amt}); });
    $('btn-give-item')?.addEventListener('click', () => { if(!checkDuty()) return; const id=parseInt($('econ-item-pid').value), item=$('econ-item-name').value, qty=parseInt($('econ-item-qty').value); if(id && item) sendToClient('giveItem', {id, item, count:qty}); });
    $('btn-set-job')?.addEventListener('click', () => { if(!checkDuty()) return; const id=parseInt($('econ-job-pid').value), job=$('econ-job-name').value, grade=parseInt($('econ-job-grade').value); if(id && job) sendToClient('setJob', {id, job, grade}); });
 
    $('qb-revive')?.addEventListener('click', () => { if(!checkDuty()) return; const id=parseInt($('econ-quick-pid').value); if(id) sendToClient('revive', {id}); });
    $('qb-heal')?.addEventListener('click', () => { if(!checkDuty()) return; const id=parseInt($('econ-quick-pid').value); if(id) sendToClient('heal', {id}); });
    $('qb-del-veh')?.addEventListener('click', () => { if(!checkDuty()) return; const id=parseInt($('econ-quick-pid').value); if(id) sendToClient('deleteVehicle', {id}); });
    $('qb-tp-to')?.addEventListener('click', () => { if(!checkDuty()) return; const id=parseInt($('econ-quick-pid').value); if(id) sendToClient('teleport', {id}); });
    $('qb-tp-here')?.addEventListener('click', () => { if(!checkDuty()) return; const id=parseInt($('econ-quick-pid').value); if(id) sendToClient('teleportToMe', {id}); });
    $('qb-kick')?.addEventListener('click', () => { if(!checkDuty()) return; const id=parseInt($('econ-quick-pid').value); if(id) { const p = state.players.find(x => x.id === id); if(p) quickKick(p); else sendToClient('kick', {id, reason:'Kick rapide'}); } });

    // World Toggles
    $('noclip-toggle')?.addEventListener('change', e => sendToClient('toggleTool', {tool: 'noclip', active: e.target.checked}));
    $('godmode-toggle')?.addEventListener('change', e => sendToClient('toggleTool', {tool: 'godmode', active: e.target.checked}));
    $('invis-toggle')?.addEventListener('change', e => sendToClient('toggleTool', {tool: 'invisible', active: e.target.checked}));
    $('freeze-toggle')?.addEventListener('change', e => sendToClient('toggleTool', {tool: 'freeze', active: e.target.checked}));

    // Staff Chat Logic
    const sChatInput = $('staff-chat-input');
    const sChatSendBtn = $('btn-staff-chat-send');
    const sendMessage = () => {
        const msg = sChatInput.value.trim();
        if (msg.length > 0) {
            sendToClient('sendStaffMessage', { 
                message: msg,
                channel: 'global',
                replyTo: state.replyingTo ? { name: state.replyingTo.sender_name, message: state.replyingTo.message } : null
            });
            sChatInput.value = '';
            cancelReply();
        }
    };
    
    window.replyToMessage = (index) => {
        const msg = state.staffChat[index];
        if (!msg) return;
        state.replyingTo = msg;
        const preview = $('chat-reply-preview');
        if (preview) {
            preview.innerHTML = `
                <div class="crp-inner">
                    <div class="crp-text">Réponse à <b>${esc(msg.sender_name)}</b> : <span>${esc(msg.message)}</span></div>
                    <div class="crp-close" onclick="cancelReply()">&times;</div>
                </div>
            `;
            preview.classList.remove('hidden');
        }
        sChatInput.focus();
    };

    window.cancelReply = () => {
        state.replyingTo = null;
        const preview = $('chat-reply-preview');
        if (preview) preview.classList.add('hidden');
    };

    sChatSendBtn?.addEventListener('click', sendMessage);
    sChatInput?.addEventListener('keydown', e => {
        if (e.key === 'Enter') sendMessage();
    });

    $('btn-chat-mention')?.addEventListener('click', () => {
        const val = sChatInput.value;
        const pos = sChatInput.selectionStart || 0;
        sChatInput.value = val.substring(0, pos) + '@' + val.substring(pos);
        sChatInput.focus();
        setTimeout(() => {
            sChatInput.setSelectionRange(pos + 1, pos + 1);
        }, 10);
    });

    $('report-search')?.addEventListener('input', () => {
        if (typeof renderReports === 'function') renderReports();
    });

    // PRU: Submit on Enter
    $('pru-reason')?.addEventListener('keydown', (e) => {
        if (e.key === 'Enter' && !e.shiftKey) {
            e.preventDefault();
            $('btn-pru-send')?.click();
        }
    });

    // ── NEW: REPORT SEARCH & REFRESH ───────────────────────────
    $('btn-show-leaderboard-page')?.addEventListener('click', () => {
        $('reports-view-main').classList.add('hidden');
        $('reports-view-leaderboard').classList.remove('hidden');
        sendToClient('getReportsLeaderboard');
    });

    $('btn-back-to-reports')?.addEventListener('click', () => {
        $('reports-view-leaderboard').classList.add('hidden');
        $('reports-view-main').classList.remove('hidden');
    });

    $('btn-refresh-reports-main')?.addEventListener('click', () => {
        sendToClient('requestReports');
        showToast('Actualisation des reports...', 'info');
    });

    $('sanction-search')?.addEventListener('input', () => {
        renderBans();
        renderWarns();
        renderJails();
        renderGhosts();
    });

    $('btn-refresh-sanctions-v4')?.addEventListener('click', () => {
        sendToClient('requestSanctions');
        showToast('Actualisation des sanctions...', 'info');
    });

    // Sub-pills for Sanctions tab
    document.querySelectorAll('#tab-sanctions .pill').forEach(pill => {
        pill.addEventListener('click', () => {
            const parent = pill.closest('.tab');
            parent.querySelectorAll('.pill').forEach(p => p.classList.remove('active'));
            parent.querySelectorAll('.sub-content').forEach(c => {
                c.classList.remove('active');
                c.classList.add('hidden');
            });
            
            pill.classList.add('active');
            const sub = pill.dataset.sub;
            const subEl = $(`sub-${sub}`);
            if (subEl) {
                subEl.classList.remove('hidden');
                subEl.classList.add('active');
            }
        });
    });

    // Sub-pills for Vehicles tab
    document.querySelectorAll('#tab-vehicles .pill').forEach(pill => {
        pill.addEventListener('click', () => {
            const parent = pill.closest('.tab');
            parent.querySelectorAll('.pill').forEach(p => p.classList.remove('active'));
            parent.querySelectorAll('.vsub-content').forEach(c => {
                c.classList.remove('active');
                c.classList.add('hidden');
            });
            
            pill.classList.add('active');
            const vsub = pill.dataset.vsub;
            const subEl = $(`vsub-${vsub}-content`);
            if (subEl) {
                subEl.classList.remove('hidden');
                subEl.classList.add('active');
            }

            // Toggle transparency for customs
            const panel = $('panel');
            if (panel) {
                if (vsub === 'customs') {
                    panel.classList.add('customs-mode');
                    if (typeof refreshCurrentVehicleMods === 'function') refreshCurrentVehicleMods();
                } else {
                    panel.classList.remove('customs-mode');
                    if (typeof renderVehicleCatalog === 'function') renderVehicleCatalog();
                }
            }
        });
    });

    // Handle initial state if needed
    window.state = {
        currentVehicleMods: null
    };

    // Vehicle Catalog Search & Filters
    $('catalog-search')?.addEventListener('input', (e) => {
        const search = e.target.value;
        const activeCat = document.querySelector('.cat-filter.active')?.dataset.category || 'all';
        renderVehicleCatalog(activeCat, search);
    });

    document.querySelectorAll('.cat-filter').forEach(btn => {
        btn.addEventListener('click', () => {
            document.querySelectorAll('.cat-filter').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            const search = $('catalog-search')?.value || '';
            renderVehicleCatalog(btn.dataset.category, search);
        });
    });
    
    // Vehicle Spawn Preview
    $('veh-model')?.addEventListener('input', (e) => {
        if (typeof updateVehiclePreview === 'function') {
            updateVehiclePreview(e.target.value);
        }
    });

    // Interactive Vehicle Rotation in Customs Mode
    let isDragging = false;
    let lastMouseX = 0;

    const mainEl = $('main');
    if (mainEl) {
        mainEl.addEventListener('mousedown', (e) => {
            const panel = $('panel');
            if (panel && panel.classList.contains('customs-mode')) {
                // Only drag if clicking on the background, not on a button/input
                if (e.target === mainEl || e.target.classList.contains('tab') || e.target.classList.contains('vsub-content')) {
                    isDragging = true;
                    lastMouseX = e.clientX;
                }
            }
        });

        window.addEventListener('mousemove', (e) => {
            if (isDragging) {
                const deltaX = e.clientX - lastMouseX;
                lastMouseX = e.clientX;
                sendToClient('rotateVehicle', { delta: deltaX * -0.5 });
            }
        });

        window.addEventListener('mouseup', () => {
            isDragging = false;
        });
    }

    // Vehicle customs category switching
    document.querySelectorAll('.vc-category').forEach(cat => {
        cat.addEventListener('click', () => {
            document.querySelectorAll('.vc-category').forEach(c => c.classList.remove('active'));
            document.querySelectorAll('.vc-panel').forEach(p => {
                p.classList.add('hidden');
                p.classList.remove('active');
            });
            cat.classList.add('active');
            const panelId = `vc-content-${cat.dataset.cat}`;
            const panel = $(panelId);
            if (panel) {
                panel.classList.remove('hidden');
                panel.classList.add('active');
            }
        });
    });

    // Populate customs on tab click
    document.querySelector('.pill[data-vsub="customs"]')?.addEventListener('click', () => {
        if (typeof renderVehicleCustoms === 'function') renderVehicleCustoms();
    });

    $('btn-add-vehicle-catalog')?.addEventListener('click', () => {
        openModal('Ajouter un véhicule au catalogue', `
            <div class="m-field">
                <label>Nom du véhicule (Affichage)</label>
                <input type="text" id="av-name" placeholder="Ex: Ma Super Voiture"/>
            </div>
            <div class="m-field">
                <label>Modèle (Spawn Code)</label>
                <input type="text" id="av-model" placeholder="Ex: sultanrs"/>
            </div>
            <div class="m-field">
                <label>URL de l'image (Optionnel)</label>
                <input type="text" id="av-image" placeholder="Ex: https://lien-image.com/car.png"/>
            </div>
            <div class="m-field">
                <label>Catégorie</label>
                <select id="av-type">
                    <option value="Super">Super</option>
                    <option value="Sport">Sport</option>
                    <option value="Muscle">Muscle</option>
                    <option value="SUV">SUV</option>
                    <option value="Off-Road">Off-Road</option>
                    <option value="Moto">Motos</option>
                    <option value="Helico">Hélicos</option>
                    <option value="Avion">Avions</option>
                    <option value="Utilitaire">Utilitaire</option>
                    <option value="Service">Service</option>
                </select>
            </div>
        `, () => {
            const name = $('av-name').value.trim();
            const model = $('av-model').value.trim();
            const type = $('av-type').value;
            const image = $('av-image').value.trim();

            if (!name || !model) {
                showToast('Veuillez remplir tous les champs', 'error');
                return;
            }

            sendToClient('addVehicleToCatalog', { name, model, type, image });
            showToast(`Requête d'ajout pour ${name} envoyée...`, 'info');
        });
    });

    $('btn-save-custom-veh')?.addEventListener('click', () => {
        openModal('Sauvegarder le Véhicule Actuel', `
            <div class="m-field">
                <label>Nom du véhicule (Affichage)</label>
                <input type="text" id="sav-name" placeholder="Ex: Sultan RS Custom"/>
            </div>
            <div class="m-field">
                <label>URL de l'image (Optionnel)</label>
                <input type="text" id="sav-image" placeholder="Ex: https://lien-image.com/car.png"/>
            </div>
            <div class="m-field">
                <label>Catégorie</label>
                <select id="sav-type">
                    <option value="Super">Super</option>
                    <option value="Sport">Sport</option>
                    <option value="Muscle">Muscle</option>
                    <option value="SUV">SUV</option>
                    <option value="Off-Road">Off-Road</option>
                    <option value="Moto">Motos</option>
                    <option value="Helico">Hélicos</option>
                    <option value="Avion">Avions</option>
                    <option value="Utilitaire">Utilitaire</option>
                    <option value="Service">Service</option>
                </select>
            </div>
        `, () => {
            const name = $('sav-name').value.trim();
            const type = $('sav-type').value;
            const image = $('sav-image').value.trim();

            if (!name) {
                showToast('Veuillez donner un nom au véhicule', 'error');
                return;
            }

            sendToClient('saveCurrentVehicleToCatalog', { name, type, image });
            showToast(`Enregistrement du véhicule en cours...`, 'info');
        });
    });

    // Staff Mode initialization (Isolated to prevent crashes)
    try {
        if (typeof initStaffMode === 'function') initStaffMode();
    } catch(e) {
        console.error('[bl_admin] Error initializing Staff Mode:', e);
    }
});

window.openGiveVehicleModal = () => {
    openModal('Donner un véhicule (Propriété)', `
        <div class="m-field">
            <label>ID du Joueur</label>
            <input type="number" id="gv-id" placeholder="Ex: 1"/>
        </div>
        <div class="m-field">
            <label>Modèle du véhicule</label>
            <input type="text" id="gv-model" value="${$('veh-model')?.value || ''}" placeholder="Ex: adder"/>
        </div>
        <div class="m-field">
            <label>Plaque (Optionnel)</label>
            <input type="text" id="gv-plate" placeholder="BLOODL3AK" maxlength="8"/>
        </div>
        <p style="font-size: 11px; color: var(--muted2); margin-top: 10px;">Le véhicule sera ajouté à la base de données du joueur comme s'il l'avait acheté.</p>
    `, () => {
        const id = parseInt($('gv-id').value);
        const model = $('gv-model').value.trim();
        const plate = $('gv-plate').value.trim().substring(0, 8).toUpperCase();
        if (id && model) {
            sendToClient('giveVehicleToPlayer', { targetId: id, model: model, plate: plate });
            showToast('Envoi du véhicule en cours...', 'info');
        }
    });
};

window.openColorPicker = () => {
    openModal('Peinture Personnalisée', `
        <div class="m-field">
            <label>Choisir la couleur (RGB)</label>
            <input type="color" id="cp-hex" style="height: 50px; width: 100%; border-radius: 8px; background: none; border: 1px solid var(--border2);"/>
        </div>
    `, () => {
        const hex = $('cp-hex').value;
        const r = parseInt(hex.slice(1, 3), 16);
        const g = parseInt(hex.slice(3, 5), 16);
        const b = parseInt(hex.slice(5, 7), 16);
        sendToClient('vehicleAction', { action: 'color', r, g, b });
    });
};

function showServerAnnounce(admin, message) {
    const el = document.createElement('div');
    el.className = 'announce-fullscreen';
    el.innerHTML = `
        <div class="ann-content">
            <div class="ann-header">ANNONCE ADMINISTRATIVE</div>
            <div class="ann-msg">${esc(message)}</div>
            <div class="ann-footer">Signé par <span>${esc(admin)}</span></div>
        </div>
    `;
    document.body.appendChild(el);
    setTimeout(() => el.classList.add('active'), 100);
    setTimeout(() => {
        el.classList.remove('active');
        setTimeout(() => {
            if (el.parentNode) document.body.removeChild(el);
        }, 500);
    }, 10000); 
}
// ── VOICE DISPATCH LOGIC ────────────────────────────────────────

let mediaRecorder;
let audioChunks = [];
let voiceTimerInterval;
let voiceStartTime;

async function startVoiceRecording() {
    try {
        const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
        const mimeType = MediaRecorder.isTypeSupported('audio/webm;codecs=opus') ? 'audio/webm;codecs=opus' : 'audio/webm';
        mediaRecorder = new MediaRecorder(stream, { mimeType });
        audioChunks = [];

        console.log('[bl_admin] Starting voice recording with mime:', mimeType);

        mediaRecorder.ondataavailable = (event) => {
            if (event.data.size > 0) audioChunks.push(event.data);
        };

        mediaRecorder.onstop = async () => {
            console.log('[bl_admin] Voice recording stopped. Chunks:', audioChunks.length);
            const audioBlob = new Blob(audioChunks, { type: mimeType });
            const reader = new FileReader();
            reader.readAsDataURL(audioBlob);
            reader.onloadend = () => {
                state.pendingVoice = reader.result;
                console.log('[bl_admin] Voice base64 ready (length):', state.pendingVoice.length);
                showToast('Message vocal enregistré !', 'success');
            };
            stream.getTracks().forEach(track => track.stop());
        };

        mediaRecorder.start();
        state.isRecordingVoice = true;
        voiceStartTime = Date.now();
        $('pru-voice-toggle').classList.add('recording');
        $('voice-timer').classList.remove('hidden');
        
        voiceTimerInterval = setInterval(() => {
            const diff = Math.floor((Date.now() - voiceStartTime) / 1000);
            $('voice-timer').textContent = `0:${diff < 10 ? '0' : ''}${diff}`;
            if (diff >= 10) stopVoiceRecording();
        }, 500);

    } catch (err) {
        console.error('Microphone error:', err);
        showToast('Erreur microphone : ' + err.message, 'error');
    }
}

function stopVoiceRecording() {
    if (mediaRecorder && state.isRecordingVoice) {
        mediaRecorder.stop();
        state.isRecordingVoice = false;
        clearInterval(voiceTimerInterval);
        $('pru-voice-toggle').classList.remove('recording');
        $('voice-timer').classList.add('hidden');
    }
}

window.playAudio = (base64) => {
    if (!base64 || base64 === 'null' || base64.length < 100) {
        showToast('Aucun audio disponible ou format invalide', 'error');
        return;
    }
    console.log('[bl_admin] Playing audio (length):', base64.length);
    const audio = new Audio(base64);
    audio.volume = 1.0;
    audio.play().then(() => {
        console.log('[bl_admin] Audio playing successfully');
    }).catch(e => {
        console.error('[bl_admin] Audio playback error:', e);
        showToast('Erreur lecture audio (Vérifiez vos paramètres)', 'error');
    });
};

// ... existing code ...
window.showTPZoneMenu = (pId) => {
    const list = $('tp-zones-list');
    if (!list) return;
    
    list.innerHTML = '';
    const zones = state.config?.TPZones || [];
    
    zones.forEach(zone => {
        const el = document.createElement('div');
        el.className = 'tp-zone-item';
        el.textContent = zone.label;
        el.onclick = () => {
            sendToClient('tpPlayerToZone', { targetId: pId, x: zone.x, y: zone.y, z: zone.z });
            window.closeModal('modal-tpzones');
            showToast(`TP de l'ID ${pId} vers ${zone.label}...`, 'success');
        };
        list.appendChild(el);
    });
    
    $('modal-tpzones').classList.remove('hidden');
};

function copyToClipboard(text) {
    const el = document.createElement('textarea');
    el.value = text;
    document.body.appendChild(el);
    el.select();
    document.execCommand('copy');
    document.body.removeChild(el);
    showToast('Copié dans le presse-papier !', 'info');
}

function updateReportsHUD(isNew = false) {
    const rw = $('reports-widget');
    const rVal = $('rw-count-val');
    if (rVal) rVal.innerText = state.reports.length;
    
    if (rw) {
        if (state.reports.length > 0) {
            rw.classList.remove('hidden');
            if (isNew) {
                rw.classList.add('new-report');
                setTimeout(() => rw.classList.remove('new-report'), 5000);
            }
        } else {
            rw.classList.add('hidden');
        }
    }
}

function updateStaffHUD() {
    const hud = $('staff-hud');
    if (!hud) return;

    const noclip = state.activeTools?.noclip;
    const delgun = state.activeTools?.delgun;

    const nEl = $('hud-noclip');
    const dEl = $('hud-delgun');

    if (noclip) nEl?.classList.remove('hidden'); else nEl?.classList.add('hidden');
    if (delgun) dEl?.classList.remove('hidden'); else dEl?.classList.add('hidden');

    if (noclip || delgun) {
        hud.classList.remove('hidden');
    } else {
        hud.classList.add('hidden');
    }

    // Sync Vanish button in HUD
    const vBtn = $('hqa-vanish');
    if (vBtn) {
        const isVanish = state.activeTools?.vanish;
        vBtn.classList.toggle('active', isVanish);
    }
}

window.toggleHUDVanish = () => {
    const active = !state.activeTools?.vanish;
    sendToClient('vanish', { active });
};

function quickTempBan(p) {
    // Define window helper functions for interactive elements in the modal
    window.setSanctionDuration = (btn, value) => {
        document.querySelectorAll('.preset-btn').forEach(b => {
            b.classList.remove('active');
            b.style.borderColor = 'var(--border2)';
            b.style.background = 'var(--bg3)';
            b.style.color = '#fff';
        });
        btn.classList.add('active');
        const customWrapper = document.getElementById('custom-duration-wrapper');
        if (value === 'perm') {
            btn.style.borderColor = 'rgba(220,38,38,0.5)';
            btn.style.background = 'rgba(220,38,38,0.2)';
            btn.style.color = 'var(--red2)';
            if (customWrapper) {
                customWrapper.style.opacity = '0.3';
                customWrapper.style.pointerEvents = 'none';
            }
        } else {
            btn.style.borderColor = 'var(--red2)';
            btn.style.background = 'rgba(220,38,38,0.05)';
            btn.style.color = 'var(--red2)';
            if (customWrapper) {
                customWrapper.style.opacity = '1';
                customWrapper.style.pointerEvents = 'auto';
            }
            const num = parseInt(value) || 1;
            const unit = value.replace(num, '') || 'h';
            const valInput = document.getElementById('tb-time-val');
            const unitInput = document.getElementById('tb-time-unit');
            if (valInput) valInput.value = num;
            if (unitInput) unitInput.value = unit;
        }
        const timeInput = document.getElementById('tb-time');
        if (timeInput) timeInput.value = value;
    };

    window.updateCustomDuration = () => {
        const valInput = document.getElementById('tb-time-val');
        const unitInput = document.getElementById('tb-time-unit');
        const num = valInput ? (valInput.value || 1) : 1;
        const unit = unitInput ? (unitInput.value || 'h') : 'h';
        const timeInput = document.getElementById('tb-time');
        if (timeInput) timeInput.value = num + unit;
        
        document.querySelectorAll('.preset-btn').forEach(b => {
            b.classList.remove('active');
            b.style.borderColor = 'var(--border2)';
            b.style.background = 'var(--bg3)';
            b.style.color = '#fff';
        });
    };

    window.setSanctionReason = (reason) => {
        const reasonInput = document.getElementById('tb-reason');
        if (reasonInput) reasonInput.value = reason;
    };

    const modalHTML = `
        <style>
            .preset-btn:hover {
                background: rgba(220, 38, 38, 0.15) !important;
                border-color: rgba(220, 38, 38, 0.4) !important;
                color: var(--red2) !important;
            }
            .preset-btn.active {
                border-color: var(--red2) !important;
                background: rgba(220, 38, 38, 0.1) !important;
                color: var(--red2) !important;
            }
            .reason-btn:hover {
                background: var(--bg2) !important;
                border-color: var(--red2) !important;
                color: #fff !important;
            }
        </style>
        <div class="sanction-form" style="display:flex; flex-direction:column; gap:16px; color:#fff; text-align:left;">
            <div class="m-field">
                <label style="font-weight:700; font-size:13px; color:var(--muted); margin-bottom:6px; display:block;">Durée du Bannissement</label>
                <div class="duration-presets" style="display:grid; grid-template-columns:repeat(4, 1fr); gap:8px;">
                    <button type="button" class="preset-btn active" data-val="1h" style="padding:10px; background:rgba(220,38,38,0.05); border:1px solid var(--red2); border-radius:8px; color:var(--red2); cursor:pointer; font-weight:700; transition:all 0.2s;" onclick="setSanctionDuration(this, '1h')">1 Heure</button>
                    <button type="button" class="preset-btn" data-val="1d" style="padding:10px; background:var(--bg3); border:1px solid var(--border2); border-radius:8px; color:#fff; cursor:pointer; font-weight:700; transition:all 0.2s;" onclick="setSanctionDuration(this, '1d')">1 Jour</button>
                    <button type="button" class="preset-btn" data-val="7d" style="padding:10px; background:var(--bg3); border:1px solid var(--border2); border-radius:8px; color:#fff; cursor:pointer; font-weight:700; transition:all 0.2s;" onclick="setSanctionDuration(this, '7d')">7 Jours</button>
                    <button type="button" class="preset-btn" data-val="perm" style="padding:10px; background:rgba(220,38,38,0.1); border:1px solid rgba(220,38,38,0.3); border-radius:8px; color:var(--red2); cursor:pointer; font-weight:700; transition:all 0.2s;" onclick="setSanctionDuration(this, 'perm')">Permanent</button>
                </div>
            </div>
            
            <div class="m-field" id="custom-duration-wrapper" style="display:grid; grid-template-columns: 2fr 1fr; gap:10px; transition:opacity 0.2s;">
                <div>
                    <label style="font-weight:700; font-size:13px; color:var(--muted); margin-bottom:6px; display:block;">Valeur personnalisée</label>
                    <input type="number" id="tb-time-val" value="1" placeholder="Ex: 30" style="width:100%; padding:11px; background:var(--bg3); border:1px solid var(--border2); border-radius:8px; color:#fff; outline:none; box-sizing:border-box;" oninput="updateCustomDuration()"/>
                </div>
                <div>
                    <label style="font-weight:700; font-size:13px; color:var(--muted); margin-bottom:6px; display:block;">Unité</label>
                    <select id="tb-time-unit" style="width:100%; padding:11px; background:var(--bg3); border:1px solid var(--border2); border-radius:8px; color:#fff; outline:none; height:41px; box-sizing:border-box;" onchange="updateCustomDuration()">
                        <option value="m">Minutes</option>
                        <option value="h" selected>Heures</option>
                        <option value="d">Jours</option>
                    </select>
                </div>
            </div>
            
            <input type="hidden" id="tb-time" value="1h" />
            
            <div class="m-field">
                <label style="font-weight:700; font-size:13px; color:var(--muted); margin-bottom:6px; display:block;">Raison du Bannissement</label>
                <input type="text" id="tb-reason" placeholder="Spécifiez ou choisissez une raison..." style="width:100%; padding:11px; background:var(--bg3); border:1px solid var(--border2); border-radius:8px; color:#fff; outline:none; margin-bottom:8px; box-sizing:border-box;"/>
                
                <div class="reason-presets" style="display:flex; flex-wrap:wrap; gap:6px;">
                    <button type="button" class="reason-btn" style="padding:6px 10px; background:var(--bg3); border:1px solid var(--border2); border-radius:6px; color:var(--muted); cursor:pointer; font-size:11px; transition:all 0.15s;" onclick="setSanctionReason('Trolling / Insultes')">Troll</button>
                    <button type="button" class="reason-btn" style="padding:6px 10px; background:var(--bg3); border:1px solid var(--border2); border-radius:6px; color:var(--muted); cursor:pointer; font-size:11px; transition:all 0.15s;" onclick="setSanctionReason('No RP / Freekill')">No RP</button>
                    <button type="button" class="reason-btn" style="padding:6px 10px; background:var(--bg3); border:1px solid var(--border2); border-radius:6px; color:var(--muted); cursor:pointer; font-size:11px; transition:all 0.15s;" onclick="setSanctionReason('Modding / Cheat')">Cheat / Modding</button>
                    <button type="button" class="reason-btn" style="padding:6px 10px; background:var(--bg3); border:1px solid var(--border2); border-radius:6px; color:var(--muted); cursor:pointer; font-size:11px; transition:all 0.15s;" onclick="setSanctionReason('Force RP / Powergaming')">Powergaming</button>
                </div>
            </div>
        </div>
    `;

    openModal('Sanctionner ' + p.name, modalHTML, () => {
        const timeInput = document.getElementById('tb-time');
        const reasonInput = document.getElementById('tb-reason');
        const timeStr = timeInput ? (timeInput.value || '1h') : '1h';
        const reason = reasonInput ? (reasonInput.value || 'Non RP') : 'Non RP';
        let seconds = 0;
        
        if (timeStr !== 'perm') {
            const val = parseInt(timeStr) || 0;
            const lowerStr = timeStr.toLowerCase();
            if (lowerStr.includes('d')) seconds = val * 86400;
            else if (lowerStr.includes('h')) seconds = val * 3600;
            else if (lowerStr.includes('m')) seconds = val * 60;
            else seconds = val * 60; // Default to minutes
        }
        
        sendToClient('banPlayer', {id: p.id, reason: reason, durationSeconds: seconds});
    });
}

function quickJail(p) {
    openModal('Jail: ' + p.name, `
        <div class="m-field"><label>Temps (Minutes)</label><input type="number" id="j-time" placeholder="15"/></div>
    `, () => {
        sendToClient('jailPlayer', {id: p.id, duration: parseInt($('j-time').value)});
    });
}

// ==========================================
//  ENVIRONMENT (WORLD) TAB CONTROLLER
// ==========================================
window.changeWeather = (weatherType) => {
    if (!checkDuty()) return;
    
    // Update active UI classes
    document.querySelectorAll('#tab-world .weather-btn').forEach(btn => {
        if (btn.dataset.weather === weatherType) {
            btn.classList.add('active');
        } else {
            btn.classList.remove('active');
        }
    });
    
    // Update metric preview badge
    const activeText = $('active-weather-text');
    if (activeText) {
        activeText.textContent = weatherType.toUpperCase();
    }
    
    // Send event to server
    sendToClient('setWeather', { weather: weatherType });
    showToast(`Météo mise à jour : <b>${weatherType}</b>`, 'info');
};

window.setTimeQuick = (hour, minute) => {
    if (!checkDuty()) return;
    
    // Update sliders and badge values
    const hourSlider = $('slider-hour');
    const minuteSlider = $('slider-minute');
    const hourVal = $('val-hour');
    const valMinute = $('val-minute');
    
    if (hourSlider) hourSlider.value = hour;
    if (minuteSlider) minuteSlider.value = minute;
    if (hourVal) hourVal.textContent = hour.toString().padStart(2, '0') + 'h';
    if (valMinute) valMinute.textContent = minute.toString().padStart(2, '0') + 'm';
    
    // Send event to server
    sendToClient('setTime', { hour, minute });
    showToast(`Temps mis à jour : <b>${hour.toString().padStart(2, '0')}:${minute.toString().padStart(2, '0')}</b>`, 'info');
};

// Debounce slider updates to prevent network spamming while dragging
let timeSliderTimeout = null;
window.onTimeSliderChange = () => {
    const hour = parseInt($('slider-hour')?.value || 12);
    const minute = parseInt($('slider-minute')?.value || 0);
    
    const hourVal = $('val-hour');
    const valMinute = $('val-minute');
    
    if (hourVal) hourVal.textContent = hour.toString().padStart(2, '0') + 'h';
    if (valMinute) valMinute.textContent = minute.toString().padStart(2, '0') + 'm';
    
    if (timeSliderTimeout) clearTimeout(timeSliderTimeout);
    timeSliderTimeout = setTimeout(() => {
        if (!checkDuty()) return;
        sendToClient('setTime', { hour, minute });
    }, 200);
};

let isWeatherFrozen = false;
window.toggleFreezeWeatherBtn = () => {
    if (!checkDuty()) return;
    isWeatherFrozen = !isWeatherFrozen;
    const btn = document.getElementById('btn-freeze-weather');
    if (btn) {
        if (isWeatherFrozen) {
            btn.classList.add('active');
            btn.querySelector('.vtb-icon').textContent = '🔒';
            btn.querySelector('.vtb-text').textContent = 'Météo Figée';
        } else {
            btn.classList.remove('active');
            btn.querySelector('.vtb-icon').textContent = '❄️';
            btn.querySelector('.vtb-text').textContent = 'Figer la Météo';
        }
    }
    sendToClient('toggleFreezeWeather', { active: isWeatherFrozen });
    showToast(isWeatherFrozen ? 'Météo figée avec succès !' : 'Météo libérée avec succès !', isWeatherFrozen ? 'warning' : 'info');
};

let isTimeFrozen = false;
window.toggleFreezeTimeBtn = () => {
    if (!checkDuty()) return;
    isTimeFrozen = !isTimeFrozen;
    const btn = document.getElementById('btn-freeze-time');
    if (btn) {
        if (isTimeFrozen) {
            btn.classList.add('active');
            btn.querySelector('.vtb-icon').textContent = '🔒';
            btn.querySelector('.vtb-text').textContent = 'Temps Figé';
        } else {
            btn.classList.remove('active');
            btn.querySelector('.vtb-icon').textContent = '⏱️';
            btn.querySelector('.vtb-text').textContent = 'Figer le Temps';
        }
    }
    sendToClient('toggleFreezeTime', { active: isTimeFrozen });
    showToast(isTimeFrozen ? 'Temps figé avec succès !' : 'Temps libéré avec succès !', isTimeFrozen ? 'warning' : 'info');
};

window.syncWorldStateUI = (worldState) => {
    if (!worldState) return;

    // 1. Sync Active Weather Buttons
    if (worldState.weather) {
        const weatherType = worldState.weather.toUpperCase();
        document.querySelectorAll('#tab-world .weather-btn').forEach(btn => {
            if (btn.dataset.weather === weatherType) {
                btn.classList.add('active');
            } else {
                btn.classList.remove('active');
            }
        });
        const activeText = $('active-weather-text');
        if (activeText) {
            activeText.textContent = weatherType;
        }
    }

    // 2. Sync Hour Slider & Badge
    if (typeof worldState.hour !== 'undefined') {
        const hourSlider = $('slider-hour');
        const hourVal = $('val-hour');
        if (hourSlider) hourSlider.value = worldState.hour;
        if (hourVal) hourVal.textContent = worldState.hour.toString().padStart(2, '0') + 'h';
    }

    // 3. Sync Minute Slider & Badge
    if (typeof worldState.minute !== 'undefined') {
        const minuteSlider = $('slider-minute');
        const valMinute = $('val-minute');
        if (minuteSlider) minuteSlider.value = worldState.minute;
        if (valMinute) valMinute.textContent = worldState.minute.toString().padStart(2, '0') + 'm';
    }

    // 4. Sync Blackout Checkbox
    if (typeof worldState.blackout !== 'undefined') {
        const blackoutToggle = $('toggle-blackout');
        if (blackoutToggle) blackoutToggle.checked = worldState.blackout;
    }

    // 5. Sync Freeze Weather Button
    if (typeof worldState.freezeWeather !== 'undefined') {
        isWeatherFrozen = worldState.freezeWeather;
        const weatherBtn = document.getElementById('btn-freeze-weather');
        if (weatherBtn) {
            if (isWeatherFrozen) {
                weatherBtn.classList.add('active');
                weatherBtn.querySelector('.vtb-icon').textContent = '🔒';
                weatherBtn.querySelector('.vtb-text').textContent = 'Météo Figée';
            } else {
                weatherBtn.classList.remove('active');
                weatherBtn.querySelector('.vtb-icon').textContent = '❄️';
                weatherBtn.querySelector('.vtb-text').textContent = 'Figer la Météo';
            }
        }
    }

    // 6. Sync Freeze Time Button
    if (typeof worldState.freezeTime !== 'undefined') {
        isTimeFrozen = worldState.freezeTime;
        const timeBtn = document.getElementById('btn-freeze-time');
        if (timeBtn) {
            if (isTimeFrozen) {
                timeBtn.classList.add('active');
                timeBtn.querySelector('.vtb-icon').textContent = '🔒';
                timeBtn.querySelector('.vtb-text').textContent = 'Temps Figé';
            } else {
                timeBtn.classList.remove('active');
                timeBtn.querySelector('.vtb-icon').textContent = '⏱️';
                timeBtn.querySelector('.vtb-text').textContent = 'Figer le Temps';
            }
        }
    }
};
