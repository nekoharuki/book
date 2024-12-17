<% if user_requested_status==1  %>
<%= link_to "#{item.item_requested.title}を配送できました", "/items/delivery/#{@hashids.encode(item.item_requested.id)}/#{@hashids.encode(item.item_offered.id)}", class: "btn btn-primary mt-2" %>
<%end%>

<% if user_offered_status==1 %>
<%= link_to "#{item.item_offered.title}を配送できました", "/items/delivery/#{@hashids.encode(item.item_offered.id)}/#{@hashids.encode(item.item_requested.id)}", class: "btn btn-primary mt-2" %>
<% end %>
