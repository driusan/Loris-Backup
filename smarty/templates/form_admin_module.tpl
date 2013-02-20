<br/>
<form method="post" name="admin_module" id="admin_module">


    <!-- table title -->

       <ul id="config">
       {foreach from=$config_list item=element}
		    
		    	<div width="100%">
		    	 {if !$config_elements[$element].Parent}
		    	 	{assign var="parent-id" value="$element"}
		    	 	<ul id="{$element}">
		    	 		<span width="50%"><a href="">{$config_elements[$element].Name}</a></span>
		    	 		{foreach from=$config_list item=element}
			    	 		{if $parent eq $config_elements[$element].Parent}
		    	 				<li id="{$element}"> 
		    	 					<span width="50%"><a href="">{$config_elements[$element].Name}</a></span>
		    	 					<input type="text" value = "{$config_elements[$element].Value}"></input>
		    	 				</li>
		    	 			{/if}
		    	 		{/foreach}
		    	 	</ul>
		    	 	
		    	 {/if}
		        </div>
	        
	    {/foreach}
	    </ul>

{$form.hidden}
</form>