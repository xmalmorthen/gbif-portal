<script type="text/html" id="tmpl-tag-drupal">
 <% _.each( feed.nodes, function(i){ %>
  <div class="result">
    <h3><%= i.node.type %></h3>
    <h2><a href="${cfg.drupal}/page/<%= i.node.nid %>" title="<%= i.node.title %>"><%= i.node.title %></a></h2>
    <p><%= i.node.body %></p>
    <div class="footer">
      <p><%= i.node.created %></p>
    </div>
  </div>
 <% }); %>
</script>

<script type="text/html" id="tmpl-datasets-drupal">
  <ul>
  <% _.each( _.first(feed.nodes, 3), function(i){
    //TODO: remove temp defaults for Tim Hirsch
    _.defaults(i.node, {image: "http://portaldev.gbif.org/sites/drupaldev.gbif.org/files/styles/featured/public/images/2013-August/202/f_Forest_close_to_the_Mana_River_at_Angoule%CC%82me%2C_French_Guiana.%20Photo%20by%20Wilkinson%20M%2C%20Sherratt%20E%2C%20Starace%20F%2C%20Gower%20DJ.png"});
%>
    <li>
      <a href="<@s.url value='/dataset/'/><%= i.node.field_datasetkey %>">
        <img src="<%= i.node.image %>" width="271" height="171">
      </a>
      <a id="<%= i.node.field_datasetkey %>" class="title" href="<@s.url value='/dataset/'/><%= i.node.field_datasetkey %>"><%= i.node.title %></a>
      <p><%= i.node.body %></p>
    </li><%
      // add dataset title from registry, see helpers.js
      getDatasetDetail(i.node.field_datasetkey, function(ds){
        $("#" + i.node.field_datasetkey).attr("title", ds.title).text(ds.title);
      });
    }); %>
  </ul>
</script>

<script type="text/html" id="tmpl-rss-google">
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

<script type="text/html" id="tmpl-mendeley-publications">
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
