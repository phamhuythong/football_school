var indexFilterForm = document.getElementById('index-filter-form');
var indexFilterSelect = document.getElementById('index-filter-select');
indexFilterSelect.addEventListener('change', function(){
  indexFilterForm.submit();
});
