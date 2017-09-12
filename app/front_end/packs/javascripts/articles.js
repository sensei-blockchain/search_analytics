import 'materialize-css/dist/js/materialize'

let ajaxAutocompleteInput, search_query

$("#autocomplete-input").on('keyup', function(e) {
  if (e.keyCode == 13 && $(this).val() !== '') {
    searchArticles($(this).val())
    return false
  }

  if (search_query !== 'undefined' && search_query === $(this).val()){
    return false
  }

  search_query = $(this).val()

  if (search_query.length === 0){
    InitializeAutoComplete()
    return false
  }

  if( typeof ajaxAutocompleteInput !== 'undefined') {
    ajaxAutocompleteInput.abort();
  }

  ajaxAutocompleteInput =  $.getJSON('/articles/autocomplete', {input: search_query}, (data) => {
    let autocompleteData = {}
    $.each(data, (index, title) => {
      autocompleteData[title] = ''
    })
    InitializeAutoComplete(autocompleteData)
  })
})

function InitializeAutoComplete(autocompleteData) {

  if( typeof autocompleteData == 'undefined') {
    $('ul.autocomplete-content').html('')
    return false
  }

  $('#autocomplete-input').autocomplete({
    data: autocompleteData,
    limit: 5,
    onAutocomplete: function(val) {
      searchArticles(val)
    },
    minLength: 1,
  })
}

function searchArticles(val) {
  $.ajax({
    type: 'GET',
    dataType: 'json',
    url: '/articles/search_articles',
    data: { search_query: val }
  });
  $("#autocomplete-input").val('')
  $('.no-article').removeClass('hide')
}
