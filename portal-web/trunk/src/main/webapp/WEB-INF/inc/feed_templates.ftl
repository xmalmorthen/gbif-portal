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

<script type="text/html" id="mendeley-publications">
 <% _.each( feed, function(pub){ %>
  <div class="publication">
    <h3>
        <% if (pub.authors.length > 3) { %>
          <span class="author"><%= pub.authors[0].surname %>, <%= pub.authors[0].forename.substring(0,1) %>. et al.</span>
        <% } else { %>
          <% _.each( pub.authors, function(auth){%>
          <span class="author"><%= auth.surname %>, <%= auth.forename.substring(0,1) %>.</span>
          <% }); %>
        <% } %>
        <%= pub.year %>
    </h3>
    <h2><a href="<%= pub.url %>" title="<%= pub.title %>"><%= pub.title %></a></h2>
    <p class="journal">
      <% if (pub.publication_outlet.length > 1 && pub.publication_outlet.substring(0,1) != "[") { %>
          <em><%= pub.publication_outlet%></em><%
          if (pub.volume) {
            %><span class="volume"><%= pub.volume %></span><%
          };
          if (pub.issue) {
            %><span class="issue"><%= pub.issue %></span><%
          };
          if (pub.pages) {
            %><span class="pages"><%= pub.pages %></span><%
          }
        } %>
    </p>
    <p><%= pub.abstract %> </p>
    <% if (pub.keywords.length > 0) { %>
      <ul class="keywords">
          <% _.each( pub.keywords, function(k){ %>
          <li><%= k %></li>
          <% }); %>
      </ul>
    <% } %>
  </div>
 <% }); %>
</script>
