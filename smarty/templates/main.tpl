<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" style="height:100%">
<head>
    <title>{$study_title}</title>

    <link rel="stylesheet" href="{$css}" type="text/css" />
    <link rel="shortcut icon" href="images/mni_icon.ico" type="image/ico" />
    <link type="text/css" href="css/jqueryslidemenu.css" rel="Stylesheet" />
    <link type="text/css" href="css/jquery-ui-1.8.2.custom.css" rel="Stylesheet" />	

    <script src="js/jquery/jquery-1.4.2.min.js" type="text/javascript"></script>
    <script type="text/javascript" src="js/jquery/jquery-ui-1.8.2.custom.min.js"></script>
    {if $test_name_js}
    <script type="text/javascript" src="{$test_name_js}"></script>
    {/if}

    {literal}
    <script language="javascript" type="text/javascript"> 
    {* This section is in the main.tpl instead of a different .js file
       because it references some smarty template variables. We should
       look into moving this out so that we can run standard linting
       tools on it and to make the main.tpl cleaner. 
       
       Can the variables be retrieved from the GET parameters using
       purely JS?
        - Dave 
        *}
    <!--
    var FeedbackButtonBoolean;

    function FeedbackButtonClicked() {
        document.cookie = "FeedbackButtonBoolean = true";
    {/literal}
        var thisUrl = "feedback_bvl_popup.php?test_name={$test_name}&candID={$candID}&sessionID={$sessionID}&commentID={$commentID}";
        {literal}
        window.open(thisUrl, "MyWindow", "width=800, height=600, resizable=yes, scrollbars=yes, status=no, toolbar=no, location=no, menubar=no");
    }

    function feedback_bvl_popup(features) { 
        if (getCookie('FeedbackButtonBoolean')) {
        {/literal}
        var myUrl = "feedback_bvl_popup.php?test_name={$test_name}&candID={$candID}&sessionID={$sessionID}&commentID={$commentID}";
        {literal}
        window.open(myUrl, "MyWindow", "width=800, height=600, resizable=yes, scrollbars=yes, status=no, toolbar=no, location=no, menubar=no");
        }
    }
    function open_help_section(){
        {/literal}
        var helpurl = "context_help_popup.php?test_name={$test_name}";
        {literal}
        window.open(helpurl);
    }

    function getCookie(c_name) {
        "use strict";
        var cookies = document.cookie.split("; "),
            i,
            cookie;
        for (i = 0; i < cookies.length; i += 1) {
            cookie = cookies[i].split("=");
            if (cookie[0] === c_name) {
                return cookie[1];
            }
        }
        return undefined;
    }

    //-->
    </script>
    {/literal}
    <script type="text/javascript" src="js/jquery/jquery-ui-1.8.2.custom.min.js"></script>
    <script type="text/javascript" src="js/jquery/jqueryslidemenu.js"></script>
</head>
<body 
    {if $PopUpFeedbackBVL && ($user.permissions.superuser==true || $user.permissions.access_all_profiles==true || $user.user_from_study_site==true)}
    onload="feedback_bvl_popup();" 
    {/if}>
    {* Is this div necessary? Can't we just add any styling to the body tag? *}
    <div id="page">
    {* If the page is being loaded for an AJAX tab (ie. stats), don't include
       all the header/styling information *}
    {if $dynamictabs neq "dynamictabs"}
    {* Header menu *}
        <table width="100%" class="header">
            <tr>
                <th align="left" id="jsheader">
                    <div id="slidemenu" class="jqueryslidemenu">
                        <ul>
                            <li><a href="main.php"><img width=20 src=images/home-icon.png></a></li>
                            {foreach from=$tabs item=tab}
                            {if $tab.visible == 1}
                            <li><a href="#">{$tab.label}</a>
                                <ul>
                                {foreach from=$subtab item=mySubtab}
                                    {if $tab.label == $mySubtab.parent}
                                        {if $mySubtab.label == "Data Query Tool"}
                                    <a href="{$mySubtab.link}" target="_blank">{$mySubtab.label}</a>
                                        {else}
                                    <a href="{$mySubtab.link}">{$mySubtab.label}</a>
                                        {/if}
                                    {/if}
                                {/foreach}
                                </ul>
                            </li> 
                            {/if}
                            {/foreach}
                        </ul>
                        <ul style="float:right">
                            <li><a href="#">{$user.Real_name}</a>
                                <ul>
                                    <li><a href="main.php?test_name=user_accounts&subtest=my_preferences">My Preferences</a></li>
                                    <li><a href="main.php?logout=true">Log Out</a></li>
                                </ul>
                            </li>
                        </ul>
                    </div>
                    <div class="site">
                        &nbsp;&nbsp;  Site: {$user.Site} &nbsp;|
                    </div>
                    <div id="slidemenu" style="float:right" class="jqueryslidemenu">
                        <ul>
                            <li><a href="#" onclick="FeedbackButtonClicked()"><img width=17 src=images/pencil.gif></a></li>
                            <li><a href="#" onClick="MyWindow=window.open('context_help_popup.php?test_name={$test_name}','MyWindow','toolbar=yes,location=yes,directories=yes,status=yes,menubar=yes,scrollbars=yes,resizable=yes,width=800,height=400'); return false;"><img width=17 src=images/help.gif></a></li>
                        </ul>
                    </div>
                </th>
            </tr>
        </table>
    {* End if dynamic tabs. *}
    {/if}
        <table border="0" cellpadding="3" cellspacing="2" width="100%" class="mainlayout">
            <tr>
            {if $lastURL != ""}
                <!-- left section -->
                <td class="tabox sidenav" valign="top">
                {if $lastURL != "" && $sessionID != ""}
                    <ul class="controlPanel">
                        {$control_panel}
                    </ul>
                {/if}
            {/if}
                </td>
                <!-- main page table tags -->
                <td width="100%" class="bgGradient" valign="top">
                <!-- Start workspace area -->
                {if $crumbs != "" && $dynamictabs neq "dynamictabs"}
                    <!-- bread crumb -->
                    <div id="breadcrumb">
                        {section name=crumb loop=$crumbs}
                            <a href="main.php?{$crumbs[crumb].query}">{$crumbs[crumb].text}</a>
                            {if not $smarty.section.crumb.last}&gt; {/if}
                        {/section}

                    </div>
                {/if}

            {if $error_message != ""}
                    <p>
                    The following errors occured while attempting to display this page:

                    <ul>
                        {section name=error loop=$error_message}
                        <li><strong>{$error_message[error]}</strong></li>
                        {/section}
                    </ul>

                    If this error persists, please report a bug using <a target="mantis" href="{$mantis_url}">Mantis</a>.
                    </p>
                    <p>
                        <a href="javascript:history.back(-1)">Please click here to go back</a>.
                    </p>
            {elseif $test_name == ""}
            {* Main page with no test_name specified *}
                    <h1>Welcome to the LORIS Database!</h1>
                    <p>This database provides an on-line mechanism to store both MRI and behavioral data collected from various locations. Within this framework, there are several tools that will make this process as efficient and simple as possible. For more detailed information regarding any aspect of the database, please click on the Help icon at the top right. Otherwise, feel free to contact us at the DCC. We strive to make data collection almost fun.</p>
            {else}
                {* Header table with candidate info. 
                   FIXME: This should go into a different template. *}
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
                    <table cellpadding="2" class="list" style='width:700px'>
                    <!-- visit statuses -->
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

               {* Finally, include the workspace! *}
                    <!-- included file -->        
                    <table width="90%">
                        <tr>
                            <td>{$workspace}</td>
                        </tr>
                    </table>
            {* End if error_message or test_name not set block, close all
               the main table tags so that we can start the footer tags*}
            {/if} 
            </td>
        </tr>
    </table>
    {* Don't include the footer if page is dynamically loaded via ajax *}
    {if $dynamictabs neq "dynamictabs"}
    <table class="MainFooter" align="center">
        <tr>
            <td width="100%">
                {* Is this needed or can we just give the ul an id and style
                   it *}
                <div id="footerLinks">
                    <ul id="navlist" style="margin-top: 5px; margin-bottom: 2px;" >
                        <li id="active">|</li>
                        {foreach from=$links item=link}
                        <li><a href="{$link.url}" target="{$link.windowName}">{$link.label}</a> | </li>
                        {/foreach}
                    </ul>
                </div>
            </td>
        </tr>
        <tr>
            <td align="center" colspan="1" style="color:#fff" >
                Powered by LORIS &copy; 2013. All rights reserved.
            </td>
        </tr>
        <tr>
            <td align="center" colspan="1">
                <a href="http://cbrain.mcgill.ca" style="color: #348b8d;" target="_blank">Created by ACElab</a>
            </td>
        </tr>
    </table>
    {* End dynamic tabs if *}
    {/if}
    </div>
    </body>
</html>
