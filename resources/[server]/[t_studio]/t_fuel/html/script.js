const slider = document.getElementById('fuelSlider');
const displayAmt = document.getElementById('displayAmt');
const displayPrice = document.getElementById('displayPrice');
const pricePerLiter = 2;

slider.oninput = function() {
    displayAmt.innerText = this.value + " L";
    displayPrice.innerText = "$ " + (this.value * pricePerLiter);
}

window.addEventListener('message', function(event) {
    if (event.data.action === "openMenu") {
        document.getElementById('container').style.display = "block";
        document.getElementById('currentFuel').innerText = event.data.fuel + " / 100 L";
    }
    if (event.data.action === "closeMenu") {
        document.getElementById('container').style.display = "none";
    }
});

function closeMenu() {
    document.getElementById('container').style.display = "none";
    fetch(`https://${GetParentResourceName()}/close`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    });
}

function confirmFuel() {
    fetch(`https://${GetParentResourceName()}/confirm`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ amount: slider.value })
    });
}

document.onkeyup = function(data) { if (data.which == 27) closeMenu(); };