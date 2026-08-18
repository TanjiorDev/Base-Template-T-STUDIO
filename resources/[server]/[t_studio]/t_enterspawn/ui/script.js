const body = document.body;
const button = document.getElementById('btn');
let submitting = false;

function setVisible(visible) {
    body.classList.toggle('is-visible', visible);
}

async function validate() {
    if (submitting) return;
    submitting = true;
    button.disabled = true;

    try {
        const response = await fetch(`https://${GetParentResourceName()}/CloseUI`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8'
            },
            body: JSON.stringify({})
        });

        if (!response.ok) {
            throw new Error(`NUI callback failed (${response.status})`);
        }

        setVisible(false);
    } catch (error) {
        console.error('[enterspawn] CloseUI error:', error);
        submitting = false;
        button.disabled = false;
    }
}

window.addEventListener('message', (event) => {
    const data = event.data;

    if (data?.action === 'showConnexion') {
        submitting = false;
        button.disabled = false;
        setVisible(true);
    } else if (data?.action === 'hideConnexion') {
        setVisible(false);
    }
});

button.addEventListener('click', validate);
