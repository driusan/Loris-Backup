<!-- start the selection table -->
<form method="post" action="main.php?test_name=civetstatus">
<table border="0" valign="top" class="std">
    <tr>
        <th nowrap="nowrap" colspan="4">Selection Filter</th>
    </tr>
    <tr>
        <td nowrap="nowrap">{$form.cbraintask.label}</td>
        <td nowrap="nowrap">{$form.cbraintask.html}</td>
        <td nowrap="nowrap">{$form.cbraintaskstatus.label}</td>
        <td nowrap="nowrap">{$form.cbraintaskstatus.html}</td>
    </tr>
    <tr>
        <td nowrap="nowrap">{$form.sourcefile.label}</td>
        <td nowrap="nowrap">{$form.sourcefile.html}</td>
        <td nowrap="nowrap">&nbsp;</td>
        <td nowrap="nowrap">&nbsp;</td>
    </tr>
    <tr>
        <td nowrap="nowrap">Actions:</td>
        <td colspan="3"><input type="submit" name="filter" value="Show Data" class="button" />&nbsp;<input type="button" name="reset" value="Clear Form" class="button" onclick="location.href='main.php?test_name=civetstatus&reset=true'">
    </tr>

</table>
</form>

<!--  title table with pagination -->

<div id="pagelinks">
<table border="0" valign="bottom" width="100%">
<tr>
    <!-- display pagination links -->
    <td align="right">{$page_links}</td>
</tr>
</table>
</div>


<!-- start data table -->
<div id="datatable">
<table border="0" class="fancytable">
<tr>
 <th nowrap="nowrap">No.</th>
    <!-- print out column headings - quick & dirty hack -->
    {section name=header loop=$headers}
        {if $header eq 'Surfaces/Left'}
        <th nowrap="nowrap"><a href="main.php?test_name=civetstatus&filter[order][field]={$headers[header].name}&filter[order][fieldOrder]={$headers[header].fieldOrder}">{$headers[header].displayName}</a>.</th>
        {else}
        <th nowrap="nowrap"><a href="main.php?test_name=civetstatus&filter[order][field]={$headers[header].name}&filter[order][fieldOrder]={$headers[header].fieldOrder}">{$headers[header].displayName}</a></th>
        {/if}
    {/section}
</tr>

{section name=item loop=$items}
    <tr>
    <!-- print out data rows -->
    {section name=piece loop=$items[item]}
    <td nowrap="nowrap">
        {if $items[item][piece].name == "Source_File"}
            <a href="mri_browser.php?sessionID={$items[item][piece].SessionID}">{$items[item][piece].value}</a>
        {else}
            {$items[item][piece].value}
        {/if}
    </td>
    {/section}
    </tr>           
{sectionelse}
    <tr><td colspan="8">Nothing found</td></tr>
{/section}
                    
<!-- end data table -->
</table>
</div>

