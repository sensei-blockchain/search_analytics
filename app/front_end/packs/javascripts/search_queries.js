$('.analytic-reset').on('click', function() {
  let searchQueryId = $(this).data("id")
  $.ajax({
    type: 'PUT',
    dataType: 'json',
    url: `/search_queries/${searchQueryId}/reset_search_query_hits`,
    beforeSend: Rails.CSRFProtection,
    success: (data) => {
      $(`#search_query_hits_${searchQueryId}`).text(0)
    }
  })
})

$('.reset-all-analytics').on('click', function() {
  $.ajax({
    type: 'PUT',
    dataType: 'json',
    url: '/search_queries/reset_all_search_queries_hits',
    beforeSend: Rails.CSRFProtection,
    success: (data) => {
      $(".search-query-hits").text(0)
    }
  })
})
