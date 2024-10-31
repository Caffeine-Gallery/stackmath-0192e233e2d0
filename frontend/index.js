import { backend } from 'declarations/backend';

const inputElement = document.getElementById('input');
const calculateButton = document.getElementById('calculate');
const clearButton = document.getElementById('clear');
const resultElement = document.getElementById('result');
const spinnerElement = document.getElementById('spinner');

calculateButton.addEventListener('click', async () => {
  const input = inputElement.value.trim();
  if (input) {
    try {
      spinnerElement.classList.remove('d-none');
      const result = await backend.calculate(input);
      resultElement.textContent = `Result: ${result}`;
    } catch (error) {
      resultElement.textContent = `Error: ${error.message}`;
    } finally {
      spinnerElement.classList.add('d-none');
    }
  }
});

clearButton.addEventListener('click', () => {
  inputElement.value = '';
  resultElement.textContent = '';
});
