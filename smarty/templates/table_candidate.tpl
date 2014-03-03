{if $candID != ""}
<!-- table with candidate profile info -->
<table cellpadding="2" class="list" style='width:600px'>
<!-- column headings -->
    <tr>
        <th nowrap="nowrap">DOB</th>
        {if $candidate.EDC!=""}
        <th nowrap="nowrap">EDC</th>
        {/if}
        <th nowrap="nowrap">Gender</th>
        {if $candidate.ProjectTitle != ""}
        <th nowrap="nowrap">Project</th>
        {/if}
        {foreach from=$candidate.DisplayParameters item=value key=name}
        <th nowrap="nowrap">{$name}</th>
        {/foreach}
        {if $sessionID != ""}
            <th nowrap="nowrap">Visit Label</th>
            <th nowrap="nowrap">Visit to Site</th>
            <th nowrap="nowrap">Subproject</th>
            <th nowrap="nowrap">MR Scan Done</th>
            <th nowrap="nowrap">Within Optimal</th>
            <th nowrap="nowrap">Within Permitted</th>
            {if $SupplementalSessionStatuses }
                {foreach from=$timePoint.status item=status key=name}
                <th nowrap="nowrap">{$name}</th>
                {/foreach}
            {/if}
        {/if}
    </tr>
    <tr>
    <!-- candidate data -->
        <td nowrap="nowrap">{$candidate.DoB}</td>
        {if $candidate.EDC!=""}
            <td nowrap="nowrap">{$candidate.EDC}</td>
        {/if}
        <td nowrap="nowrap">{$candidate.Gender}</td>
        {if $candidate.ProjectTitle != ""}
            <td nowrap="nowrap">{$candidate.ProjectTitle}</td>
        {/if}
        {foreach from=$candidate.DisplayParameters item=value key=name}
            <td nowrap="nowrap">{$value}</td>
        {/foreach}
        {if $sessionID != ""}
            <!-- timepoint data -->
            <td nowrap="nowrap">{$timePoint.Visit_label}</td>
            <td nowrap="nowrap">{$timePoint.PSC}</td>
            <td nowrap="nowrap">{$timePoint.SubprojectTitle}</td>
            <td nowrap="nowrap">{$timePoint.Scan_done|default:"<img alt=\"Data Missing\" src=\"images/help2.gif\" width=\"12\" height=\"12\" />"}</td>
            <td nowrap="nowrap">{if $timePoint.WindowInfo.Optimum}Yes{else}No{/if}</td>
            <td nowrap="nowrap" {if not $timePoint.WindowInfo.Optimum}class="error"{/if}>{if $timePoint.WindowInfo.Permitted}Yes{else}No{/if}</td>
            {if $SupplementalSessionStatuses }
                {foreach from=$timePoint.status item=status}
                <td nowrap="nowrap">{$status}</td>
                {/foreach}
            {/if}
        {/if}
    </tr>
</table>
{/if}

{if $sessionID != "" && $candID != ""}
<!-- table with visit statuses -->
<table cellpadding="2" class="list" style='width:700px'>
    <tr>
        <th nowrap="nowrap" colspan="3">Stage</th>
        <th nowrap="nowrap" colspan="3">Status</th>
        <th nowrap="nowrap" colspan="2">Date</th>
    </tr>
    <tr>
        <td nowrap="nowrap" colspan="3">Screening</td>
        <td nowrap="nowrap" colspan="3">{$timePoint.Screening}</td>
        <td nowrap="nowrap" colspan="2">{$timePoint.Date_screening}</td>
    </tr>
    <tr>
        <td nowrap="nowrap" colspan="3">Visit</td>
        <td nowrap="nowrap" colspan="3">{$timePoint.Visit}</td>
        <td nowrap="nowrap" colspan="2">{$timePoint.Date_visit}</td>
    </tr>
    <tr>
        <td nowrap="nowrap" colspan="3">Approval</td>
        <td nowrap="nowrap" colspan="3">{$timePoint.Approval}</td>
        <td nowrap="nowrap" colspan="2">{$timePoint.Date_approval}</td>
    </tr>
</table>
{/if}
