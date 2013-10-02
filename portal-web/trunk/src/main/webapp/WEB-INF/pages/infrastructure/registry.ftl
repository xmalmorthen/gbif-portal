<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>Registry</title>
</head>
<#assign tab="registry"/>
<#include "/WEB-INF/pages/infrastructure/inc/infoband.ftl" />
<body>

<@common.article id="about" title="About" titleRight="Quick links" class="rte">
  <div class="left">
    <p>The registry is a core component of the architecture responsible for providing the authoritative source of information on GBIF participants (Nodes), institutions (e.g. data publishers), datasets, networks their interrelationships and the means to identify and access them.</p> 
    <p>As a distributed network, the registry serves a central coordination mechanism to (e.g.) allow publishers to declare their existence and for data integrating components to discover how to access published datasets and interoperate with the publisher.</p>  
  </div>
  <div class="right">
    <ul>
      <li><a href="#purpose" title="Purpose">Purpose</a></li>
      <li><a href="#componentArchitecture" title="Component architecture">Component architecture</a></li>
      <li><a href="#evolution" title="Evolution">Evolution</a></li>
      <li><a href="#relationship" title="Relationship with other registries">Relationship with other registries</a></li>
    </ul>
  </div>
</@common.article>

<@common.article id="purpose" title="Purpose"  titleRight="See also" class="rte">
  <div class="left">
<p>The role of the registry can be summarised as a component offering:</p>
<ul>
  <li>An authoritative source of information (metadata) on institutions, datasets, technical services and other key entities as required by registry partners.  Due to the nature of the network and tools in use, multiple versions of this information are often available.  Where this occurs, the registry aims to provide the most complete representation by merging sources and harmonizing conflicting views where possible.  This simplifies consumption to clients by providing a unified view of metadata in a consistent format.  Links to external representations available through other formats (e.g. EML[TODO:link], DiGIR [TODO: link]  etc) are available to clients.</li>
  <li>A source of information on inter-relationships between dataset, institutions and other entities according to the needs of the registry partners.  Datasets can be hosted by one party on behalf of another, and might themselves be a superset of other datasets.  Modelling of dataset relationships provides an indication of where duplicate content might exist and how to correctly determine the attribute chain for all parties involved in the data management lifecycle.  </li>
  <li>A trustworthy identifier assignment (minting) service for institutions and datasets.  Identifiers are allocated as Universally Unique IDentifiers (UUID) on first registration, packaged and will be made available as Digital Object Identifiers (DOI) for external use.  Other uses might use only the UUID format of the identifier.  Additional packaging of the identifier will be offered as required by the registry partners.</li>
  <li>An identifier resolution service allowing external clients to submit a known identifier and resolve this to the registry assigned identifier.  Thus clients already using (e.g.) a Biodiversity Collection Index (BCI) identifier can interact with the registry using BCI identifiers.  The number of identifier systems recognised is expected to grow continuously as more systems are connected.</li>
  <li>A mechanism to help coordinate distributed system activities by</li>
  <ol>
    <li>providing preferred technical access points where multiple routes exist</li>
    <li>offering stable identifiers for registered entities and</li>
    <li>providing notification services of significant events such as a dataset being registered</li>
  </ol>
  <li>A discovery mechanism for users and machines for </li>
  <ol>
    <li>Registered network entities</li>
    <li>Technical endpoints</li>
    <li>Data definitions (e.g. Standards) such as the extensions and vocabularies used in the Darwin Core Archive [link: darwin core archive] format</li>    
  </ol>
  <li>Discovery is provided through indexing of metadata, and through flexible tagging of entities using simple key value pairs of tags, optionally in a restricted namespace. Tagging may be done publicly (no namespace), allowing anyone to make use of the tag, or by maintaining a private collection of tags (private namespace).  Private tagging ensures a registry client can define their own terms (vocabulary) for tagging and be assured others cannot make changes to their tags.  An example of a public tag on a dataset might assert that <em>basisOfRecord=Specimen</em> which might be useful to many whereas a private tag in a scratchpad namespace might assert that <em>scratchpads.eu:activity = high</em> which is specific to the namespace owner and cannot be changed by others.  </li>
  <li>A technical endpoint monitoring and alerting service is expected to be included in future releases to help notify technicians of servers going offline.</li>
</ul>      
  </div>

  <div class="right">
    <ul>
      <li><a href="" title="...">...</a></li>
    </ul>
  </div>
</@common.article>

<@common.article id="componentArchitecture" title="Component architecture"  titleRight="See also" class="rte">
  <div class="left">
<p>At the heart of the registry is a PostgreSQL database [TODO: view schema] accessed exclusively through a web services API [TODO: link].  To enable faceted search, an embedded Apache SOLR index is maintained and exposed in the API.  The registry emits messages to a messaging bus (RabbitMQ) to enable components to subscribe to significant events, such as a newly registered dataset to be crawled.</p> 
<p>As it evolves, it is expected that the registry will issue Digital Object Identifiers for datasets, to help enable better data citation.</p>
<p><img src="<@s.url value='/img/infrastructure/registry.png'/>"/></p>

  </div>
  <div class="right">
    <ul>
      <li><a href="" title="...">...</a></li>
    </ul>
  </div>
</@common.article>

<@common.article id="evolution" title="Evolution"  titleRight="See also" class="rte">
  <div class="left">
<p>A registry has existed as a key component of the infrastructure since the conception of the GBIF network.  Originally built on the open industry business registry known as UDDI [ http://en.wikipedia.org/wiki/Universal_Description_Discovery_and_Integration] the registry recorded institutions, their contact information and their hosted technical services.</p>
<p>When the GBIF Data Portal was designed in 2007, data harvesting tools interacted with the registry to locate endpoints and crawl the network, building the necessary search indexes to drive the portal services.  In 2009 when the Integrated Publishing Tool [http://gbif.org/ipt] was released, the registry incorporated a RESTful web service interface enabling automatic registration of published datasets.</p>
<p>Today the registry has evolved to provide a RESTful web service API (http://portaldev.gbif.org/developer/registry), search services and means to discover data standards and vocabularies used during the data publication process.</p> 
  </div>
  <div class="right">
    <ul>
      <li><a href="" title="...">...</a></li>
    </ul>
  </div>
</@common.article>

<@common.article id="relationship" title="Relationship with other registries"  titleRight="See also" class="rte">
  <div class="left">
<p>Work is currently underway led by the Smithsonian to combine the content of three existing overlapping online registries (Index Herbariorum, BCI and biorepositories.org) and their most important functionalities into the new Global Registry of Biorepositories (GRBio).</p>
<p>All the data elements found in these three registries will be incorporated in GRBio, including the LSIDs assigned by BCI as well as BCI’s web services.  This is expected to launch in October on the domain name www.grbio.org.  The BCI has already shut down and will direct people to GRBio and biorepositories.org will do the same in October.  Improvements are planned for the GRBio that will add some remaining Index Herbariorum functionalities.</p>
<p>Once complete, parties will aim to synchronize the GBRio content with the GBIF registry content, to ensure identifiers are preserved and understood across both systems. Future collaborations might see these initiatives merge completely.</p> 
  </div>
  <div class="right">
    <ul>
      <li><a href="http://www.grbio.org" target="_blank" title="Global Registry of Biorepositories (GRBio)">Global Registry of Biorepositories (GRBio)</a></li>
      <li><a href="http://biorepositories.org" target="_blank" title="Global Registry of Biorepositories (GRBio)">Biorepositories</a></li>
    </ul>
  </div>
</@common.article>


</body>
</html>