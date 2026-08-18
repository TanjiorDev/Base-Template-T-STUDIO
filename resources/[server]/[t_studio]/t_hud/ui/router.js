(() => {
    const frameIds = ['hud-status', 'hud-clock', 'hud-speedo'];

    window.addEventListener('message', (event) => {
        for (const id of frameIds) {
            const frame = document.getElementById(id);
            if (frame && frame.contentWindow) {
                frame.contentWindow.postMessage(event.data, '*');
            }
        }
    });
})();
