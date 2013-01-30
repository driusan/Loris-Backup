<br/>
<form method="post" name="admin_module" id="admin_module">


    <!-- table title -->

       <ul id="config">
       {foreach from=$config_list item=element}
		    <li><div width="100%">
		        <span width="50%"><a href="">{$conflig_elements[$element].Name}</a>		        </span>
		        	<input type="text"> {$config_elements[$element].Value}</input>
		        	</div>
	        </li> 
	    {/foreach}
	    </ul>

{$form.hidden}
</form>