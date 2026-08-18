window.addEventListener('message', (event) => {
    const data = event.data;
    if (data.type === "update_hud") {
        document.getElementById('time').innerText = data.time;
        document.getElementById('date').innerText = data.date;
        document.getElementById('id').innerText = "ID " + data.id;
    }
});