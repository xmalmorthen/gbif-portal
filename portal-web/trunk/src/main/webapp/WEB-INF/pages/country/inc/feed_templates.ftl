<script type="text/html" id="rss-google-long">
  <ul>
    <% _.each( feed.entries, function(item){ %>
      <li>
        <h4 class="date"><%= item.publishedDate %></h4>
        <a href="<%= item.link %>" class="title"><%= item.title %></a>
        <p><%= $(item.content).text().trim().substr(0,500) %> ...</p>
        <a href="<%= item.link %>" class="read_more">Read more</a>
      </li>
    <% }); %>
  </ul>
</script>
<script type="text/html" id="rss-google">
    <ul>
      <% _.each( feed.entries, function(item){ %>
        <li>
          <h4 class="date"><%= item.publishedDate %></h4>
          <a href="<%= item.link %>" class="title"><%= item.title %></a>
          <p><%= item.contentSnippet.substr(0,150) %></p>
        </li>
      <% }); %>
    </ul>
</script>
