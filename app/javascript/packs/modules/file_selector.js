const file_select = document.getElementsByClassName('file-select')[0];
if (file_select != undefined) {
  file_select.addEventListener('change', (event) => {
    file_select.previousSibling.innerHTML = event.target.files[0].name;
    const image = document.getElementsByClassName('img-thumbnail')[0];
    image.src = URL.createObjectURL(event.target.files[0]);
  });
}
