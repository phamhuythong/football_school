const receiptCategory = document.getElementById('receipt-category');
const amount = document.getElementById('amount');
const paid = document.getElementById('paid');
const remain = document.getElementById('remain');

receiptCategory.addEventListener('change', (event) => {
  let selectedAmount = receiptCategory.options[receiptCategory.selectedIndex].text;
  selectedAmount = selectedAmount.substring(selectedAmount.lastIndexOf(' '));
  amount.value = selectedAmount.replace(/[^\d.]/g, '');
  evt = new Event('change');
  amount.dispatchEvent(evt);
});

amount.addEventListener('change', (event) => {
  paid.value = amount.value;
  evt = new Event('change');
  paid.dispatchEvent(evt);
});

paid.addEventListener('change', (event) => {
  remain.value = amount.value.replace(/[^\d.]/g, '') - paid.value.replace(/[^\d.]/g, '');
  evt = new Event('change');
  remain.dispatchEvent(evt);
});