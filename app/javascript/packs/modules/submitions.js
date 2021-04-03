const forms = document.querySelectorAll('form');
Array.from(forms).forEach((form) => {
  form.addEventListener('submit', (event) => {
    const buttons = form.querySelectorAll('button, input[type=submit]')
    Array.from(buttons).forEach((button) => {
      button.setAttribute('disabled', 'disabled');
    });
  });
});