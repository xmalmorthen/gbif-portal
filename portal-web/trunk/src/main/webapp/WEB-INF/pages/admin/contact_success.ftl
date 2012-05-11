            <#import "/WEB-INF/macros/common.ftl" as common>
            <#if contacts?has_content>              
              CONTACTS

                <ul class="team">
                <!-- This div's id name cant be changed as it is referenced by JS functionality  -->
                <div id="contactSuccess"/>
                  <#list contacts! as c>
                  <li>
                    <img src="<@s.url value='/img/minus.png'/>">
                      <@common.contact con=c />
                  </li>
                </#list>
              </ul>
            </#if>               