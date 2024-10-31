import { backend } from 'declarations/backend';

const input = document.getElementById('input');
const keys = document.querySelectorAll('.key');

let currentInput = '';

keys.forEach(key => {
    key.addEventListener('click', () => handleKeyPress(key.textContent));
});

async function handleKeyPress(value) {
    switch(value) {
        case 'ENTER':
            try {
                const result = await backend.calculate(currentInput);
                input.value = result;
                currentInput = result;
            } catch (error) {
                input.value = 'Error';
                currentInput = '';
            }
            break;
        case '←':
            currentInput = currentInput.slice(0, -1);
            input.value = currentInput;
            break;
        case '+/-':
            if (currentInput.startsWith('-')) {
                currentInput = currentInput.slice(1);
            } else {
                currentInput = '-' + currentInput;
            }
            input.value = currentInput;
            break;
        case 'R↓':
            const parts = currentInput.split(' ');
            if (parts.length > 1) {
                const last = parts.pop();
                currentInput = [...parts, parts.pop(), last].join(' ');
                input.value = currentInput;
            }
            break;
        case 'EEX':
            currentInput += 'E';
            input.value = currentInput;
            break;
        default:
            currentInput += value;
            input.value = currentInput;
    }
}
