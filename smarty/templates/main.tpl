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
    <script src="js/loris.js" language="javascript" type="text/javascript"></script>
    <script type="text/javascript" src="js/jquery/jqueryslidemenu.js"></script>
</head>
<body 
    {if $PopUpFeedbackBVL && ($user.permissions.superuser==true || $user.permissions.access_all_profiles==true || $user.user_from_study_site==true)}
    onload="feedback_bvl_popup();" 
    {/if}>
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
                </td>
            {/if}
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
                {if $candidateTables}
                    {$candidateTables}
                {/if}
                    <div id="workspace">{$workspace}</div>
            {/if} 
            </td>
        </tr>
    </table>
    {* Don't include the footer if page is dynamically loaded via ajax *}
    {if $dynamictabs neq "dynamictabs"}
    <div class="MainFooter">
        <ul id="navlist" style="margin-top: 5px; margin-bottom: 2px;" >
            {foreach from=$links item=link name=links}
            <li>
                <a href="{$link.url}" target="{$link.windowName}">{$link.label}</a>
                {if not $smarty.foreach.links.last} | {/if}
            </li>
            {/foreach}
        </ul>

        <p id="poweredby" class="FooterText">
            Powered by LORIS &copy; 2013. All rights reserved.
        </p>
        <p id="createdby" class="FooterText">
            <a href="http://cbrain.mcgill.ca" style="color: #348b8d;" target="_blank">Created by ACElab</a>
        </p>
    </div>
    {* End dynamic tabs if *}
    {/if}
    </div>
    </body>
</html>
