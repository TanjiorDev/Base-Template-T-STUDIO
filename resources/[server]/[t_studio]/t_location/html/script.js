const app = document.getElementById('app');
const vehiclesContainer = document.getElementById('vehicles');
const durationsContainer = document.getElementById('durations');
const closeBtn = document.getElementById('closeBtn');
const rentalTimer = document.getElementById('rentalTimer');
const rentalTimerValue = document.getElementById('rentalTimerValue');

let selectedDuration = 30;
let selectedMultiplier = 1;
let currentVehicles = [];
let currentDurations = [];

const defaultDurations = [
    { label: '30 minutes', minutes: 30, multiplier: 1 },
    { label: '1 heure', minutes: 60, multiplier: 2 },
    { label: '2 heures', minutes: 120, multiplier: 4 }
];

const defaultVehicles = [
    {
        label: 'Blista',
        model: 'blista',
        price: 250,
        seats: 2,
        category: 'Économique',
        image: 'https://docs.fivem.net/vehicles/blista.webp'
    },
    {
        label: 'Asterope SUV',
        model: 'asterope',
        price: 500,
        seats: 4,
        category: 'Confort',
        image: 'https://docs.fivem.net/vehicles/asterope.webp'
    },
    {
        label: 'Karin Sultan',
        model: 'sultan',
        price: 750,
        seats: 4,
        category: 'Sportive',
        image: 'https://docs.fivem.net/vehicles/sultan.webp'
    },
    {
        label: 'Bati 801',
        model: 'bati',
        price: 150,
        seats: 2,
        category: 'Moto',
        image: 'https://docs.fivem.net/vehicles/bati.webp'
    }
];

function getResourceName() {
    return typeof GetParentResourceName === 'function' ? GetParentResourceName() : 'tan_location';
}

function postNui(eventName, data = {}) {
    fetch(`https://${getResourceName()}/${eventName}`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8'
        },
        body: JSON.stringify(data)
    });
}

function getDurationText(minutes) {
    if (minutes === 30) return '/ 30 min';
    if (minutes === 60) return '/ 1 h';
    if (minutes === 120) return '/ 2 h';
    return `/ ${minutes} min`;
}

function renderDurations(durations) {
    durationsContainer.innerHTML = '';

    durations.forEach((duration) => {
        const button = document.createElement('button');
        button.className = 'duration-btn';
        button.textContent = duration.label;

        if (Number(duration.minutes) === Number(selectedDuration)) {
            button.classList.add('active');
        }

        button.addEventListener('click', () => {
            selectedDuration = Number(duration.minutes);
            selectedMultiplier = Number(duration.multiplier || 1);
            renderDurations(currentDurations);
            renderVehicles(currentVehicles);
        });

        durationsContainer.appendChild(button);
    });
}

function renderVehicles(vehicles) {
    vehiclesContainer.innerHTML = '';

    vehicles.forEach((vehicle) => {
        const finalPrice = Math.floor(Number(vehicle.price || 0) * selectedMultiplier);
        const card = document.createElement('div');
        card.className = 'vehicle-card';

        card.innerHTML = `
            <img class="vehicle-image" src="${vehicle.image}" onerror="this.style.display='none'">
            <div>
                <div class="vehicle-name">${vehicle.label}</div>
                <div class="vehicle-meta">
                    <span>👤 ${vehicle.seats} Places</span>
                    <span>⛽ ${vehicle.category}</span>
                </div>
            </div>
            <div class="price">${finalPrice}$ <small>${getDurationText(selectedDuration)}</small></div>
            <button class="rent-btn">Louer</button>
        `;

        card.querySelector('.rent-btn').addEventListener('click', () => {
            postNui('rentVehicle', {
                model: vehicle.model,
                duration: selectedDuration
            });
        });

        vehiclesContainer.appendChild(card);
    });
}

function openMenu(vehicles, durations) {
    currentVehicles = vehicles || defaultVehicles;
    currentDurations = durations || defaultDurations;

    const firstDuration = currentDurations[0] || defaultDurations[0];
    selectedDuration = Number(firstDuration.minutes || 30);
    selectedMultiplier = Number(firstDuration.multiplier || 1);

    renderDurations(currentDurations);
    renderVehicles(currentVehicles);
    app.classList.remove('hidden');
}

function closeMenu() {
    app.classList.add('hidden');
}

window.addEventListener('message', (event) => {
    const data = event.data;

    if (data.action === 'open') {
        openMenu(data.vehicles, data.durations);
    }

    if (data.action === 'close') {
        closeMenu();
    }

    if (data.action === 'rentalTimer') {
        if (data.show) {
            rentalTimerValue.textContent = data.time || '00:00';
            rentalTimer.classList.remove('hidden');
        } else {
            rentalTimer.classList.add('hidden');
        }
    }
});

closeBtn.addEventListener('click', () => {
    postNui('close');
    closeMenu();
});

document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape') {
        postNui('close');
        closeMenu();
    }
});

// Aperçu navigateur hors FiveM
if (!window.invokeNative) {
    openMenu(defaultVehicles, defaultDurations);
}
