// ============================================================
//  BLOODADMIN — HTML/JS/NOTIFICATIONS.JS
// ============================================================

const Notifications = {
    recent: new Set(),
    
    showToast(msg, type = 'info') {
        const container = document.getElementById('toasts');
        if (!container) return;

        // Prevent exact duplicates within a short timeframe
        const hash = `${type}:${msg}`;
        if (this.recent.has(hash)) return;
        this.recent.add(hash);
        setTimeout(() => this.recent.delete(hash), 2000);

        const toast = document.createElement('div');
        toast.className = `toast toast-${type}`;
        
        const titles = { success: 'Succès', error: 'Erreur', warning: 'Attention', info: 'Information' };
        const icons = {
            success: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"/></svg>',
            error: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>',
            warning: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>',
            info: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"/><line x1="12" y1="16" x2="12" y2="12"/><line x1="12" y1="8" x2="12.01" y2="8"/></svg>'
        };

        toast.innerHTML = `
            <div class="toast-inner">
                <div class="toast-icon">${icons[type] || icons.info}</div>
                <div class="toast-content">
                    <div class="toast-title">${titles[type] || 'Info'}</div>
                    <div class="toast-msg">${msg}</div>
                </div>
                <div class="toast-progress"></div>
            </div>
        `;

        container.appendChild(toast);
        
        // Click to dismiss
        let dismissed = false;
        const dismiss = () => {
            if (dismissed) return;
            dismissed = true;
            toast.style.animation = 'toast-out 0.4s ease forwards';
            setTimeout(() => toast.remove(), 400);
        };

        toast.addEventListener('click', dismiss);

        // Auto-dismiss after 5 seconds
        setTimeout(dismiss, 5000);
    }
};

// Global helper for backward compatibility or direct access
window.showToast = (msg, type) => Notifications.showToast(msg, type);
