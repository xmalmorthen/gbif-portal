<script type="text/html" id="rss-google-search">
 <% _.each( feed.entries, function(item){ %>
  <div class="result">
    <#--
    removed for now, see http://dev.gbif.org/issues/browse/PF-1017
    <h3>NEWS ITEM</h3>
    -->
    <h2><a href="<%= item.link %>" title="<%= item.title %>"><%= item.title %></a></h2>
    <p><%= $(item.content).text().trim().substr(0,500) %> ...</p>
    <div class="footer">
      <p class="date"><%= item.publishedDate %></p>
    </div>
  </div>
 <% }); %>
</script>
<script type="text/html" id="rss-google">
    <ul class="notes">
      <% _.each( feed.entries, function(item){ %>
        <li>
          <a href="<%= item.link %>" class="title"><%= item.title %></a>
          <#--
          <span class="note"><%= item.contentSnippet.substr(0,150) %></span>
           -->
          <span class="note date"><%= item.publishedDate %></span>
        </li>
      <% }); %>
    </ul>
</script>
