 <#import "/WEB-INF/macros/common.ftl" as common>
  <#if endpoints?has_content>
    ENDPOINTS<p/><ul>
    <!-- This div's id name cant be changed as it is referenced by JS functionality  -->
    
        <#list endpoints! as i>
            <img src="<@s.url value='/img/minus.png'/>">
            <@common.endpoint ep=i />
        </#list>
        <div id="endpointSuccess"/>
        </ul>
  </#if>                