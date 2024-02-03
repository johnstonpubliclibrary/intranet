<%@ Page Language="C#" AutoEventWireup="true" Async="true" Inherits="PowerPAC.search.components.ajaxResults" Codebehind="ajaxResults.aspx.cs" %>
<%@ Register TagPrefix="Polaris" TagName="ResultsNavigation" Src="./usercontrols/ctrlResultsNavigation.ascx" %>
<%@ Register TagPrefix="polaris" TagName="searchStatus" Src="../usercontrols/searchStatus.ascx" %>
<%@ Import namespace="PowerPAC.search" %>
<%@ Import namespace="PowerPAC.include" %>
<%@ Import Namespace="Polaris.ERMSClient" %>

<div id="IsPatronLoggedOn" runat="server" visible="<%# SessionObject.PatronLoggedOn %>">
</div>
<div id="IsVendorAccountPresent" runat="server" visible="<%# Is3MVendorPresent %>">
</div>
<div id="IsAxis360VendorAccountPresent" runat="server" visible="<%# IsAxisVendorPresent %>">
</div>
<div id="IsOverdriveVendorAccountPresent" runat="server" visible="<%# IsOverdriveVendorPresent %>">
</div>
<div id="IsRBdigitalVendorAccountPresent" runat="server" visible="<%# IsRBdigitalVendorPresent %>">
</div>
<div id="IsRBdigitalLicensedID" runat="server" visible="<%# IsRBdigitalLicensed %>">
</div>
    <script type="text/javascript">
        $(document).ready(function () {         
            $(".c-title-detail-actions__oneclick").on("click", function (e) {
                var id = $(this).attr('data-recordid');

                $("#oneclick_" + id).addClass('c-title-detail__disable_a_href');
                var strOK = "<%# SessionObject.GetLanguageStringPlain("PACML_OK") %>";
                PlaceOneClickHoldRequest(id, strOK, e);
            });

            <asp:PlaceHolder runat="server" visible="<%# NovelistISBNs.Length > 0%>">
                 novelistInit('<%# SessionObject.GetSearchCache().NovelistSelectProfile %>', '<%# SessionObject.GetSearchCache().NovelistSelectPassword %>', '<%# PACPath.AsExternalUrl(PathType.PACRoot, Request.IsSecureConnection) %>');
                 getLexileGoodReads(<%# SessionObject.GetSearchCache().NovelistSelectLexileEnabled ? 1 : 0 %>, <%# SessionObject.GetSearchCache().NovelistSelectGoodReadsEnabled ? 1 : 0 %>, 'Lexile', <%# NovelistISBNs %>);
            </asp:PlaceHolder>
            <asp:PlaceHolder runat="server" visible="<%# NovelistSimilarTitlesPositions.Length > 0 %>">
                 novelistInit('<%# SessionObject.GetSearchCache().NovelistSelectProfile %>', '<%# SessionObject.GetSearchCache().NovelistSelectPassword %>', '<%# PACPath.AsExternalUrl(PathType.PACRoot, Request.IsSecureConnection) %>');
                 initSimilarTitles(<%# NovelistSimilarTitlesPositions %>);
            </asp:PlaceHolder>            
       });
    </script>

<asp:PlaceHolder runat="server" Visible="<%# SessionObject.SearchCache.GooglePreviewBriefEnabled == true && GooglePreviewISBNKeys.Length > 0 %>">
    <script type="text/javascript">

        function processDynamicLinksResponse(booksInfo) 
        {
            for (id in booksInfo) 
            {
                if (booksInfo[id] && booksInfo[id].preview == 'partial' && booksInfo[id].embeddable == true)
                {
                    $('.gbs-preview-div').each(function () 
                    {
                        if ($(this).attr('id').indexOf(id) != -1) {
                            $(this).show();
                        }
                    });
                }
            }
        }
        
  

    </script>
</asp:PlaceHolder>

<Polaris:ResultsNavigation runat="server" PanelLocation="Top" Visible="<%# (SessionObject.SearchManager.Results.RowCount > 0) && !SessionObject.ModularPAC.Spoof %>" />

<div class="search-status__container container-fluid" runat="server" visible='<%# !SessionObject.SearchManager.IsLocalOnly %>'>
  <div class="row">
    <div class="col-md-9">
      <span id="search_status">
        <span><%# (IsSearchDone && (PendingResultCount <= 0)) ? SessionObject.GetLanguageString("PACML_SEARCHSTATUS_ALLRESULTSADDED") : (IsSearchDone ? SessionObject.GetLanguageString("PACML_SEARCHSTATUS_DONERETRIEVING") : SessionObject.GetLanguageString("PACML_SEARCHSTATUS_RETRIEVINGRESULTS")) %> </span>
        <asp:placeholder runat="server" visible="<%# !IsSearchDone || (IsSearchDone && (PendingResultCount > 0)) %>">(<span style="font-weight: bold;"><%# PendingResultCount.ToString() %></span> <%# SessionObject.GetLanguageString("PACML_SEARCHSTATUS_RESULTSPENDING") %>).</asp:placeholder>
      </span>
      <a id="add_results" href="#" style='<%# PendingResultCount > 0 ? "visibility: visible": "visibility: hidden" %>' onclick="javascript:ajaxMergeSearchResults();"><%# SessionObject.GetLanguageString("PACML_SEARCHSTATUS_ADDPENDINGRESULTS") %></a>
    </div>
    <div class="col-md-3">
      <div class="search-status-box__container">
        <polaris:searchStatus id="search_status_control" runat="server" Visible='<%# !SessionObject.SearchManager.IsLocalOnly %>' />
      </div>
    </div>
  </div>
</div>

<asp:PlaceHolder runat="server" Visible="<%# SessionObject.SearchManager.Results.PromotionsTable != null && SessionObject.SearchManager.Results.RowCount > 0 %>">
    <%# PACFunction.BuildFeatureItSearchDashboard(SessionObject.SearchManager.Results.PromotionsTable, PromotionsLocation, SessionObject) %>
</asp:PlaceHolder>
<div id="searchResultsDIV">
<asp:Repeater runat="server" DataSource="<%# ResultDataItemList %>">
	<ItemTemplate>   
        <div class="search__position">
            <a id="__pos-<%# ((ResultDataItem) Container.DataItem).Position %>" href="#" aria-hidden="true" aria-label="Search Result"/>  
        </div>        
        <div class="content-module content-module--search-result">  
            <div class="content-container c-title-detail__title-display">
                <div class="c-title-detail c-title-detail--initial-two-col">
                    <div class="c-title-detail__container <%# ((SessionObject.GetSearchCache().CoverImagesEnabled && (((ResultDataItem) Container.DataItem).ShortISBN.Length > 0 || ((ResultDataItem) Container.DataItem).UPC.Length > 0 || ((ResultDataItem) Container.DataItem).OCLCControlNumber.Length > 0)) || ((ResultDataItem) Container.DataItem).ThumbnailLink.Length > 0) == true ? "" : " c-title-detail__container--no-border"  %>">
                        <div class="c-title-detail-media__container c-title-detail-media__container--no-border">
                            <div class="c-title-detail__image-container"  runat="server" Visible="<%# (SessionObject.GetSearchCache().CoverImagesEnabled && (((ResultDataItem) Container.DataItem).ShortISBN.Length > 0 || ((ResultDataItem) Container.DataItem).UPC.Length > 0 || ((ResultDataItem) Container.DataItem).OCLCControlNumber.Length > 0)) || ((ResultDataItem) Container.DataItem).ThumbnailLink.Length > 0 %>">
                                <div id="srcp_<%# ((ResultDataItem) Container.DataItem).Position %>" class="hover__container" width="1%" align="center" valign="top">
                                    <asp:PlaceHolder runat="server" Visible="<%# (SessionObject.GetSearchCache().CoverImagesEnabled && (((ResultDataItem) Container.DataItem).ShortISBN.Length > 0 || ((ResultDataItem) Container.DataItem).UPC.Length > 0 || ((ResultDataItem) Container.DataItem).OCLCControlNumber.Length > 0)) || ((ResultDataItem) Container.DataItem).ThumbnailLink.Length > 0 %>">
				                                <%# GetCoverImageLink((ResultDataItem)Container.DataItem) %>
				                            </asp:PlaceHolder>
                                </div>
                            </div>
                            <div class="c-title-detail-meta">
                                <div class="c-title-detail-formats__list">
                                    <%-- 3M cloudLibrary logo --%>
                                    <asp:PlaceHolder runat="server" Visible="<%# IsDisplayEContentLibraryLogoImage((ResultDataItem)Container.DataItem) == true %>">
                                        <img class="c-title-detail-formats__img" src="<%# ((ResultDataItem)Container.DataItem).ResourceEntityIconURL %>" border="0" alt="<%# ((ResultDataItem)Container.DataItem).EncodedResourceEntityTipText %>" title="<%# ((ResultDataItem)Container.DataItem).EncodedResourceEntityTipText %>" />
                                    </asp:PlaceHolder>
                                    <%-- Format Icon (with MARC view link) --%>
                                    <asp:PlaceHolder runat="server" Visible="<%# SessionObject.GetSearchCache().LibrarianViewEnabled == true && (IsEDSRestrictedView((ResultDataItem)Container.DataItem) == false)%>">
                                        <a href="javascript:showModalBasic('<%# PACPath.AsExternalUrl(PathType.PACRoot) %>search/components/ajaxMARC.aspx?pos=<%# ((ResultDataItem) Container.DataItem).Position %>')">                 
                                            <img class="c-title-detail-formats__img" src="<%# SessionObject.GetBibFormatImageURL(((ResultDataItem) Container.DataItem).TypeOfMaterial) %>" alt="<%# GetTypeOfMaterialDescription(((ResultDataItem) Container.DataItem).TypeOfMaterial) %>" title="<%# GetTypeOfMaterialDescription(((ResultDataItem) Container.DataItem).TypeOfMaterial) %>" border="0"/>
                                        </a>
                                    </asp:PlaceHolder>
                                    <%-- Format Icon (NO MARC view link) --%>
                                    <asp:PlaceHolder runat="server" Visible="<%# SessionObject.GetSearchCache().LibrarianViewEnabled == false  ||  (SessionObject.GetSearchCache().LibrarianViewEnabled == true && (IsEDSRestrictedView((ResultDataItem)Container.DataItem) == true))%>">
                                        <img class="c-title-detail-formats__img" src="<%# SessionObject.GetBibFormatImageURL(((ResultDataItem) Container.DataItem).TypeOfMaterial) %>" alt="<%# GetTypeOfMaterialDescription(((ResultDataItem) Container.DataItem).TypeOfMaterial) %>" title="<%# GetTypeOfMaterialDescription(((ResultDataItem) Container.DataItem).TypeOfMaterial) %>" />
                                    </asp:PlaceHolder>                                
                                </div>                        
                            </div>

                            <%-- Publication Date --%>
                            <asp:PlaceHolder runat="server">                           
                                <div class="c-title-detail__3rd-party c-title-detail__pub-year"><%# GetPublicationDate((ResultDataItem)Container.DataItem) %></div>
                            </asp:PlaceHolder>
                            <%-- ONLY display this box if at least one of Google Preview, Chilifresh, ... is to be displayed --%>
                            <asp:PlaceHolder runat="server" 
                                             visible="<%# (SessionObject.GetSearchCache().ChiliFreshEnabled == true && (((ResultDataItem) Container.DataItem).ShortISBN.Length > 0 || ((ResultDataItem) Container.DataItem).UPC.Length > 0 || ((ResultDataItem) Container.DataItem).OCLCControlNumber.Length > 0)) 
                                                          || ( SessionObject.SearchCache.LibraryThingReviewsEnabled == true && ((ResultDataItem) Container.DataItem).ShortISBN.Length > 0) 
                                                          || ( SessionObject.SearchCache.GooglePreviewBriefEnabled == true && ((ResultDataItem) Container.DataItem).ShortISBN.Length > 0) 
                                                          || (SessionObject.SearchCache.OverDrivePreviewBriefEnabled == true && ((ResultDataItem) Container.DataItem).bOverdrive == true) 
                                                          || ((SessionObject.SearchCache.NovelistSelectLexileEnabled == true || SessionObject.SearchCache.NovelistSelectGoodReadsEnabled == true) && ((ResultDataItem) Container.DataItem).ShortISBN.Length > 0) %>">
                                <div class="c-title-detail__3rd-party">

                                    <%-- NoveList Lexile and GoodReads --%>
                                    <asp:PlaceHolder runat="server" visible="<%# (SessionObject.SearchCache.NovelistSelectLexileEnabled == true || SessionObject.SearchCache.NovelistSelectGoodReadsEnabled == true) && ((ResultDataItem) Container.DataItem).ShortISBN.Length > 0 %>">
                                        <div class="novelist-lgr-<%# ERMSHelper.NormalizeISBN(0, ((ResultDataItem) Container.DataItem).ShortISBN, 13) %> c-title-detail__3rd-party-item--novelist-lexile" style="height:auto; width:auto !important;">
                                        </div>
                                    </asp:PlaceHolder>
                                    <%-- ChiliFresh --%>
                                    <asp:PlaceHolder runat="server" Visible="<%# SessionObject.GetSearchCache().ChiliFreshEnabled == true && (((ResultDataItem) Container.DataItem).ShortISBN.Length > 0 || ((ResultDataItem) Container.DataItem).UPC.Length > 0 || ((ResultDataItem) Container.DataItem).OCLCControlNumber.Length > 0)  %>">
				                        <div class="chili_review c-title-detail__3rd-party-list--chilifresh" id="chili_<%# GetChiliFreshTitleID((ResultDataItem) Container.DataItem) %>_<%# ((ResultDataItem) Container.DataItem).Position %>" style="height:auto; width:auto !important;">
				                        </div>
				                    </asp:PlaceHolder>
                                    <%-- LibraryThing --%> 
                                        <div runat="server" class="librarything-ratings" visible="<%# SessionObject.SearchCache.LibraryThingReviewsEnabled == true && ((ResultDataItem) Container.DataItem).ShortISBN.Length > 0 %>"> 
                                            <%# GetLibraryThingCOINSSpan((ResultDataItem)Container.DataItem) %>
                                            <div id="ltfl_reviews_<%# ERMSHelper.NormalizeISBN(0, ((ResultDataItem) Container.DataItem).ShortISBN, 13) %>_<%# ((ResultDataItem) Container.DataItem).Position %>" class="ltfl_reviews_content"></div>
                                        </div>
                                    <%-- Google Books Preview --%>
                                    <asp:Placeholder runat="server" Visible="<%# SessionObject.SearchCache.GooglePreviewBriefEnabled == true && ((ResultDataItem) Container.DataItem).ShortISBN.Length > 0 %>">
                                        <div class="gbs-preview-div c-title-detail__3rd-party-item--google-preview" id="gbs_ISBN:<%# ERMSHelper.NormalizeISBN(0, ((ResultDataItem) Container.DataItem).ShortISBN, 13) %>_<%# ((ResultDataItem) Container.DataItem).Position %>" >
                                            <a class="gbs-preview-link" href="javascript:showModalBasicWithIframe('<%# PACPath.AsExternalUrl(PathType.PACRoot) %>search/components/ajaxGooglePreview.aspx?isbn=ISBN:<%# ERMSHelper.NormalizeISBN(0, ((ResultDataItem) Container.DataItem).ShortISBN, 13) %>','', true)">
                                                <img src="<%# SessionObject.GetThemeWebFile(ThemeWebFiles.GooglePreview) %>" title="Google Books Preview" alt="Google Books Preview" border="0" />
                                            </a>
                                        </div>
                                    </asp:Placeholder>
                                    <asp:Placeholder runat="server" Visible="<%# SessionObject.SearchCache.OverDrivePreviewBriefEnabled == true && ((ResultDataItem) Container.DataItem).bOverdrive == true %>">
                                        <div id="econtent-preview-vendor-div-<%#((ResultDataItem) Container.DataItem).VendorObjectIdentifier %>" style="display:none;">
                                            <a id="econtent-preview-vendor-<%#((ResultDataItem) Container.DataItem).VendorObjectIdentifier %>" target="_blank" class="od-preview-link" href="" >
                                                <img src="<%# SessionObject.GetThemeWebFile(ThemeWebFiles.OverdriveSample)  %>" title="OverDrive Sample" alt="OverDrive Sample" border="0" />
                                            </a>
                                        </div>
                                    </asp:Placeholder>
                            </div>
                            </asp:PlaceHolder>
                        </div>
                        <div class="c-title-detail-info__container">
                            <div class="c-title-detail-info-main__container">
                                <div class="c-title-detail-info__result-num">
                                    <%-- position data is embedded in ERMS results --%>
                                    <%-- %# ((ResultDataItem) Container.DataItem).Position % --%>
                                </div>
                            </div>
                            <div class="c-title-detail-info-secondary__container <%# IsVendorNotLicensed((ResultDataItem)Container.DataItem) %>" id="plres_<%# ((ResultDataItem)Container.DataItem).VendorObjectIdentifier != "" ? ((ResultDataItem)Container.DataItem).VendorObjectIdentifier : ((ResultDataItem) Container.DataItem).Position.ToString() %>"  <%# VendorNotLicensedGetDataItemID((ResultDataItem)Container.DataItem) %>>
				                <table cellpadding="0" cellspacing="0" width="100%" border="0">
					                <%# RenderBriefRecord((ResultDataItem) Container.DataItem) %>
                                    <asp:PlaceHolder runat="server" Visible="<%#((ResultDataItem)Container.DataItem).IsEDSTitle && !IsEDSRestrictedView(((ResultDataItem)Container.DataItem))  && ((ResultDataItem)Container.DataItem).EDSDatabaseName.Length > 0%>">
                                    <tr class="nsm-brief-secondary-zone">
                                        <td colspan=1>
                                            <div class="nsm-brief-standard-group">
                                                <span class="nsm-brief-label nsm-e17">
                                                    <%#SessionObject.GetLanguageString("PACML_EDS_DATABASELABEL")%> 
                                                </span>
                                                <span class="nsm-short-item nsm-e17">
                                                    <%# ((ResultDataItem)Container.DataItem).EDSDatabaseName %> 
                                                </span>
                                            </div>
                                        </td>
                                    </tr>
                                    </asp:PlaceHolder>
    				                <tr>
						                <td colspan=2>
                                            <div runat="server" visible="<%# IsDisplayDatabaseSource((ResultDataItem)Container.DataItem) == true %>" style="padding-top: 20px;">
                                                <img style="vertical-align: middle;" src="<%# SessionObject.GetThemeWebFile(ThemeWebFiles.Database) %>" /> <%# SessionObject.GetLanguageString("PACML_DBSOURCE") %>: <%# ((ResultDataItem)Container.DataItem).DatabaseName %>
                                            </div>
                                            <asp:placeholder runat="server" visible='<%# ((ResultDataItem) Container.DataItem).IsFusionTitle == true && ((ResultDataItem) Container.DataItem).FusionEntity != null  %>'>
                                                <br />
                                            
                                                <%# GetFusionDisplayItem((ResultDataItem)Container.DataItem) %>
                                            
                                            </asp:placeholder>
                                            <asp:PlaceHolder runat="server" Visible="<%# IsDisplayEContentLibraryLogoImage((ResultDataItem)Container.DataItem) == true %>">
                                                <div class="nsm-brief-standard-group" id="econtent-status-vendor-action<%# ((ResultDataItem)Container.DataItem).VendorObjectIdentifier %>1" >
                                                </div>
                                                <div class="nsm-brief-standard-group" id="econtent-status-vendor-action<%# ((ResultDataItem)Container.DataItem).VendorObjectIdentifier %>2" >
                                                </div>
                                            </asp:PlaceHolder>
						                </td>
					                </tr>
				                </table>
                                <%-- NoveList Similar Titles --%>
                                <asp:PlaceHolder runat="server" Visible="<%# IsDisplayNovelistSimilarTitles((ResultDataItem) Container.DataItem) == true %>">
                                    <div class="novelist-similartitles-heading" id="novelist-st_<%# ((ResultDataItem) Container.DataItem).Position %>-<%# ERMSHelper.NormalizeISBN(0, ((ResultDataItem) Container.DataItem).ShortISBN, 13) %>">
                                        <a class="novelist-similartitles-link" href="javascript:novelistShowSimilarTitlesCarousel('<%# ((ResultDataItem) Container.DataItem).Position %>-<%# ERMSHelper.NormalizeISBN(0, ((ResultDataItem) Container.DataItem).ShortISBN, 13) %>')"><%# SessionObject.GetLanguageString("PACML_NOVELIST_SIMTITLES") %> <span class="caret"></span></a>
                                    </div>
                                    <div id="novelist-st_<%# ((ResultDataItem) Container.DataItem).Position %>-carousel" style="display: none"></div>
                                </asp:PlaceHolder>
                            </div>
                        </div>
                    </div>
                    <div class="c-title-detail-actions__container">
                        <ul id="c-title-detail__button-list-<%# ((ResultDataItem)Container.DataItem).VendorObjectIdentifier %>" class="c-title-detail-actions__list" data-item-pos="<%# ((ResultDataItem)Container.DataItem).Position %>"  data-item-page="<%#  (((ResultDataItem)Container.DataItem).Position -1) / SessionObject.SearchManager.Input.SearchResultsPerPage %>">
                             
                            <%-- EDS Link - Logged In --%>
                            <asp:PlaceHolder Runat="server" Visible="<%# SessionObject.PatronLoggedOn && ((ResultDataItem) Container.DataItem).IsEDSTitle && ((ResultDataItem) Container.DataItem).EDSLinkType.Length > 0 %>">
                            <li class="c-title-detail-actions__item button-brief-availability" role="presentation">
                                <a class="c-title-detail-actions__btn" id="buttonEDS_<%# ((ResultDataItem) Container.DataItem).Position %>" href="./components/ajaxEDS.aspx?command=resourceurl&dbid=<%# ((ResultDataItem) Container.DataItem).EDSDBId %>&docid=<%# ((ResultDataItem) Container.DataItem).EDSAn %>" target="_eds-<%# ((ResultDataItem) Container.DataItem).EDSAn %>">
                                    <span class="glyphicon glyphicon-file" aria-hidden="true"></span>
                                    <%# SessionObject.GetLanguageString("PACML_EDS_READARTICLEBUTTON") %>  
				                </a>
                            </li>
				            </asp:PlaceHolder>       
                           
                            <%-- EDS Link - NOT Logged In --%>
                            <asp:PlaceHolder Runat="server" Visible="<%# SessionObject.PatronLoggedOn == false && ((ResultDataItem) Container.DataItem).IsEDSTitle && ((ResultDataItem) Container.DataItem).EDSLinkType.Length > 0 %>">
                            <li class="c-title-detail-actions__item button-brief-availability" role="presentation">
                                <a class="c-title-detail-actions__btn" id="buttonEDS_<%# ((ResultDataItem) Container.DataItem).Position %>" href="<%# PACPath.AsExternalSecureUrl(PathType.PACRoot) %>logon.aspx?src=<%# HttpUtility.UrlEncode(PACFunction.BuildDispatchURL(SessionObject, PACAction.SearchResults_Reexecute, "terms=AN+" + ((ResultDataItem) Container.DataItem).EDSAn)) %>">

                                    <span class="glyphicon glyphicon-file" aria-hidden="true"></span>
                                    <%# SessionObject.GetLanguageString("PACML_EDS_LOGINTOREADBUTTON") %>
				                </a>
                            </li>
				            </asp:PlaceHolder>       

                            <%-- EDS Link - "Custom Link" Always viewable --%>
                            <asp:PlaceHolder Runat="server" Visible="<%# ((ResultDataItem) Container.DataItem).IsEDSTitle && ((ResultDataItem) Container.DataItem).EDSCustomLinkUrl.Length > 0 %>">
                            <li class="c-title-detail-actions__item button-brief-availability" role="presentation">
                                <a class="c-title-detail-actions__btn" id="buttonEDS_<%# ((ResultDataItem) Container.DataItem).Position %>" href="<%# ((ResultDataItem) Container.DataItem).EDSCustomLinkUrl %>" target="_eds-custom-<%# ((ResultDataItem) Container.DataItem).EDSAn %>">
                                    <span class="glyphicon glyphicon-file" aria-hidden="true"></span>
                                    <%# ((ResultDataItem) Container.DataItem).EDSCustomLinkLabel %>  
				                </a>
                            </li>
				            </asp:PlaceHolder>       

                            <%-- Polaris Availability --%>
                            <asp:PlaceHolder Runat="server" Visible="<%# IsDisplayAvailabilityButton((ResultDataItem) Container.DataItem) %>">
                            <li class="c-title-detail-actions__item button-brief-availability" role="presentation">
                                <a class="c-title-detail-actions__btn" id="buttonAvailability_<%# ((ResultDataItem) Container.DataItem).Position %>"
                                    href="javascript:showModalBasicWithIframe('<%# PACPath.AsExternalUrl(PathType.PACRoot) %>search/components/ajaxavailability.aspx?fp=1&level=local&morelink=<%# IsDisplayMoreLink((ResultDataItem) Container.DataItem) %>&pos=<%# ((ResultDataItem) Container.DataItem).Position %>&bibid=<%# ((ResultDataItem) Container.DataItem).LocalRecordID %>')">
                                    <span class="glyphicon glyphicon-ok" aria-hidden="true"></span>
                                        <%# SessionObject.GetLanguageString("PACML_SEARCHRESULTS_XSL_1758") %>  
				                </a>
                            </li>
				            </asp:PlaceHolder>       
 
                            <%-- Full Display --%>
                            <li class="c-title-detail-actions__item button-brief-fulldisplay" role="presentation">
					            <a class="c-title-detail-actions__btn" href="<%# GetFullURL((ResultDataItem) Container.DataItem) %>">
                                    <span class="glyphicon glyphicon-tasks"></span>
                                    <%# GetFullDisplayLabel((ResultDataItem) Container.DataItem) %>
					            </a>
                            </li>
            
                            <%-- Hold Request --%>
                            <asp:PlaceHolder runat="server" Visible="<%# HoldRequestEnabled((ResultDataItem) Container.DataItem) %>">
                            <li class="c-title-detail-actions__item button-brief-request" role="presentation">
                            <% if (SessionObject.CurrentPatron.IsSecured == true)
                                { %>
                                    <a href="#" class="c-title-detail-actions__btn--disabled">
                                        <span class="glyphicon glyphicon-log-in" aria-hidden="true"></span>
                                        <%= SessionObject.GetLanguageString("PACML_SEARCHRESULTS_XSL_1760") %>
                                    </a>
                            <% }
                                else
                                { %>
                                    <a href="<%# GetRequestURL((ResultDataItem) Container.DataItem) %>" class="c-title-detail-actions__btn"> 
                                        <span class="glyphicon glyphicon-log-in" aria-hidden="true"></span>
                                        <%= SessionObject.GetLanguageString("PACML_SEARCHRESULTS_XSL_1760") %>
                                    </a>
                            <% } %>
                            </li>
                            </asp:PlaceHolder>
                            <%-- One Click Hold Request --%>
                            <asp:PlaceHolder runat="server" Visible="<%# OneClickHoldRequestEnabled((ResultDataItem) Container.DataItem) %>">
                            <li class="c-title-detail-actions__item button-one-click-hold" role="presentation">     
                                <a href="javascript:void(0);" class="c-title-detail-actions__btn c-title-detail-actions__oneclick" data-recordid="<%# ((ResultDataItem)Container.DataItem).LocalRecordID %>" id="oneclick_<%# ((ResultDataItem)Container.DataItem).LocalRecordID %>">
                                    <span class="glyphicon glyphicon-hand-up" aria-hidden="true"></span>
                                    <%= SessionObject.GetLanguageString("PACML_SEARCHRESULTS_1CLICK_REQUEST") %>
				                </a>
                            </li>
                           </asp:PlaceHolder>
                           <asp:PlaceHolder runat="server" Visible="<%#IsEContentVisible((ResultDataItem)Container.DataItem) == true %>">
                           <li class="c-title-detail-actions__item button-brief-econtent" role="presentation">
                               <%-- Axis360 item placehold/checkout --%>
                               <asp:PlaceHolder runat="server" Visible="<%# IsAxis360VendorItem((ResultDataItem) Container.DataItem) == true %>">
                                  <asp:PlaceHolder runat="server" Visible="<%# ((ResultDataItem)Container.DataItem).ItemIsRestricted == true && ((ResultDataItem)Container.DataItem).TemporarilyUnavailable == false %>">
                                       <div title='<%# SessionObject.GetLanguageString("PACML_EBRESTRICTED_TIP")%>' data-item-id="RB<%# ((ResultDataItem)Container.DataItem).VendorObjectIdentifier != "" ? ((ResultDataItem)Container.DataItem).VendorObjectIdentifier : ((ResultDataItem) Container.DataItem).Position.ToString() %>" class="c-title-detail-actions__btn--restricted results-title-restricted-button">
                                             <%# SessionObject.GetLanguageString("PACML_EBRESTRICTED")%>
                                        </div>
                                   </asp:PlaceHolder>
                                   <asp:PlaceHolder runat="server" Visible="<%# ((ResultDataItem)Container.DataItem).TemporarilyUnavailable == true %>">
                                       <div title='<%# SessionObject.GetLanguageString("PACML_EBNOTAVAIL_TIP")%>' data-item-id="RB<%# ((ResultDataItem)Container.DataItem).VendorObjectIdentifier != "" ? ((ResultDataItem)Container.DataItem).VendorObjectIdentifier : ((ResultDataItem) Container.DataItem).Position.ToString() %>" class="c-title-detail-actions__btn--restricted results-title-restricted-button">
                                            <%# SessionObject.GetLanguageString("PACML_EBNOTAVAIL")%>
                                       </div>
                                   </asp:PlaceHolder>
                                   <asp:PlaceHolder runat="server" Visible="<%# ((ResultDataItem)Container.DataItem).ItemIsRestricted == false && ((ResultDataItem)Container.DataItem).TemporarilyUnavailable == false %>">
                                       <div class="AxisLinksWrapper" id="AxisLinksWrapperId-<%# ((ResultDataItem)Container.DataItem).VendorObjectIdentifier %>" data-item-id="<%# ((ResultDataItem)Container.DataItem).VendorObjectIdentifier %>">
                                           <asp:PlaceHolder runat="server" Visible="<%#!SessionObject.ModularPAC.Spoof %>">
                                               <div class="axis360-results-title-action-button axis360-results-title-action-button-primary" id="axis360-link-vendor-action<%# ((ResultDataItem)Container.DataItem).Position %>">
                                                   <a class="c-title-detail-actions__btn axis360-link-nofancy <%# ((ResultDataItem)Container.DataItem).VendorObjectIdentifier %>" id="axis360-anchor-tag-<%# ((ResultDataItem)Container.DataItem).VendorObjectIdentifier %>" data-item-pos="<%# ((ResultDataItem)Container.DataItem).Position %>"  data-item-page="<%#  (((ResultDataItem)Container.DataItem).Position -1) / SessionObject.SearchManager.Input.SearchResultsPerPage %>"
                                                       href="<%# ((ResultDataItem)Container.DataItem).linkHref %>" data-link="<%# ((ResultDataItem)Container.DataItem).linkHref %>" onclick='javascript:Axis360LinkClicked("<%# ((ResultDataItem)Container.DataItem).VendorObjectIdentifier %>","<%# SessionObject.GetLanguageStringPlain("PACML_FUSION_LOGINREQUIRED") %>",event)'>
                                                       <span class="glyphicon glyphicon-plus" aria-hidden="true"></span>
                                                       <%# ((ResultDataItem)Container.DataItem).linkText%>                        
				                                   </a>
                                               </div>
                                           </asp:PlaceHolder>
                                       </div>            
                                   </asp:PlaceHolder>                    
                               </asp:PlaceHolder>
               
                              <%-- Overdrive item placehold/checkout --%>
                               <asp:PlaceHolder runat="server" Visible="<%# IsOverdriveVendorItem((ResultDataItem) Container.DataItem) == true  %>">
                                   <asp:PlaceHolder runat="server" Visible="<%# ((ResultDataItem)Container.DataItem).ItemIsRestricted == true && ((ResultDataItem)Container.DataItem).TemporarilyUnavailable == false %>">
                                       <div title='<%# SessionObject.GetLanguageString("PACML_EBRESTRICTED_TIP")%>' data-item-id="RB<%# ((ResultDataItem)Container.DataItem).VendorObjectIdentifier != "" ? ((ResultDataItem)Container.DataItem).VendorObjectIdentifier : ((ResultDataItem) Container.DataItem).Position.ToString() %>" class="c-title-detail-actions__btn--restricted results-title-restricted-button">
                                             <%# SessionObject.GetLanguageString("PACML_EBRESTRICTED")%>
                                        </div>
                                   </asp:PlaceHolder>
                                   <asp:PlaceHolder runat="server" Visible="<%# ((ResultDataItem)Container.DataItem).TemporarilyUnavailable == true %>">
                                        <div title='<%# SessionObject.GetLanguageString("PACML_EBNOTAVAIL_TIP")%>' data-item-id="RB<%# ((ResultDataItem)Container.DataItem).VendorObjectIdentifier != "" ? ((ResultDataItem)Container.DataItem).VendorObjectIdentifier : ((ResultDataItem) Container.DataItem).Position.ToString() %>"  class="c-title-detail-actions__btn--restricted results-title-restricted-button">
                                            <%# SessionObject.GetLanguageString("PACML_EBNOTAVAIL")%>
                                        </div>
                                   </asp:PlaceHolder>
                                   <asp:PlaceHolder runat="server" Visible="<%# ((ResultDataItem)Container.DataItem).ItemIsRestricted == false && ((ResultDataItem)Container.DataItem).TemporarilyUnavailable == false %>">
                                       <div class="OverdriveLinksWrapper" id="OverdriveLinksWrapperId-<%# ((ResultDataItem)Container.DataItem).VendorObjectIdentifier %>" data-item-id="<%# ((ResultDataItem)Container.DataItem).VendorObjectIdentifier %>">
                                          <asp:PlaceHolder runat="server" Visible="<%#!SessionObject.ModularPAC.Spoof %>">
                                              <div class="overdrive-results-title-action-button overdrive-results-title-action-button-primary" id='overdrive-link-vendor-action<%# ((ResultDataItem)Container.DataItem).Position %>"'>
                                                  <a class="c-title-detail-actions__btn overdrive-link-nofancy <%# ((ResultDataItem)Container.DataItem).VendorObjectIdentifier %>" id="overdrive-anchor-tag-<%# ((ResultDataItem)Container.DataItem).VendorObjectIdentifier %>" data-item-pos="<%# ((ResultDataItem)Container.DataItem).Position %>"  data-item-page="<%#  (((ResultDataItem)Container.DataItem).Position -1) / SessionObject.SearchManager.Input.SearchResultsPerPage %>"
                                                      href="<%# ((ResultDataItem)Container.DataItem).linkHref %>" data-link="<%# ((ResultDataItem)Container.DataItem).linkHref %>" onclick='javascript:OverdriveLinkClicked("<%# ((ResultDataItem)Container.DataItem).VendorObjectIdentifier %>","<%# SessionObject.GetLanguageStringPlain("PACML_FUSION_LOGINREQUIRED") %>",event)'>
                                                      <span class="glyphicon glyphicon-plus" aria-hidden="true"></span>
                                                     <%# ((ResultDataItem)Container.DataItem).linkText%>
				                                  </a>
                                              </div>
                                          </asp:PlaceHolder>
                                      </div>               
                                   </asp:PlaceHolder>                    
                               </asp:PlaceHolder>              
                                  
                               <%-- 3M vendor item placehold/checkout--%>
                               <asp:PlaceHolder runat="server" Visible="<%# IsVendorItem((ResultDataItem) Container.DataItem) == true%>">
                                   <asp:PlaceHolder runat="server" Visible="<%# ((ResultDataItem)Container.DataItem).ItemIsRestricted == true && ((ResultDataItem)Container.DataItem).TemporarilyUnavailable == false  %>">
                                        <div title='<%# SessionObject.GetLanguageString("PACML_EBRESTRICTED_TIP")%>' data-item-id="RB<%# ((ResultDataItem)Container.DataItem).VendorObjectIdentifier != "" ? ((ResultDataItem)Container.DataItem).VendorObjectIdentifier : ((ResultDataItem) Container.DataItem).Position.ToString() %>" class="c-title-detail-actions__btn--restricted results-title-restricted-button ">
                                             <%# SessionObject.GetLanguageString("PACML_EBRESTRICTED")%>
                                        </div>
                                    </asp:PlaceHolder>
                                   <asp:PlaceHolder runat="server" Visible="<%# ((ResultDataItem)Container.DataItem).TemporarilyUnavailable == true %>">
                                        <div title='<%# SessionObject.GetLanguageString("PACML_EBNOTAVAIL_TIP")%>' data-item-id="RB<%# ((ResultDataItem)Container.DataItem).VendorObjectIdentifier != "" ? ((ResultDataItem)Container.DataItem).VendorObjectIdentifier : ((ResultDataItem) Container.DataItem).Position.ToString() %>" class="c-title-detail-actions__btn--restricted results-title-restricted-button ">
                                            <%# SessionObject.GetLanguageString("PACML_EBNOTAVAIL")%>
                                    </div>
                                   </asp:PlaceHolder>
                                    
                                   <asp:PlaceHolder runat="server" Visible="<%# ((ResultDataItem)Container.DataItem).ItemIsRestricted == false && ((ResultDataItem)Container.DataItem).TemporarilyUnavailable == false %>">
                                        <div class="VendorLinksWrapper" id="VendorLinksWrapperId-<%# ((ResultDataItem)Container.DataItem).VendorObjectIdentifier %>" data-item-id="<%# ((ResultDataItem)Container.DataItem).VendorObjectIdentifier %>">
                                          <asp:PlaceHolder runat="server" Visible="<%#!SessionObject.ModularPAC.Spoof %>">
                                            <div class="results-title-action-button results-title-action-button-primary" id="link-vendor-action<%# ((ResultDataItem)Container.DataItem).Position %>">
                                                <a class=" c-title-detail-actions__btn cloud-library-3m-link-nofancy <%# ((ResultDataItem)Container.DataItem).VendorObjectIdentifier %>" id="anchor-tag-<%# ((ResultDataItem)Container.DataItem).VendorObjectIdentifier %>" data-item-pos="<%# ((ResultDataItem)Container.DataItem).Position %>"  data-item-page="<%#  (((ResultDataItem)Container.DataItem).Position -1) / SessionObject.SearchManager.Input.SearchResultsPerPage %>"
                                                    href="<%# ((ResultDataItem)Container.DataItem).linkHref %>" data-link="<%# ((ResultDataItem)Container.DataItem).linkHref %>" onclick='javascript:CloudLibraryLinkClicked("<%# ((ResultDataItem)Container.DataItem).VendorObjectIdentifier %>", "<%# SessionObject.GetLanguageStringPlain("PACML_FUSION_LOGINREQUIRED") %>",event)'>
                                                    <span class="glyphicon glyphicon-plus" aria-hidden="true"></span>
                                                    <%# ((ResultDataItem)Container.DataItem).linkText%>                  
				                                </a>
                                            </div>
                                          </asp:PlaceHolder>                 
                                        </div>
                                  </asp:PlaceHolder>
                               </asp:PlaceHolder>

                               <%-- RBdigital vendor item placehold/checkout--%>
                               <asp:PlaceHolder runat="server" Visible="<%# IsRBdigitalVendorItem((ResultDataItem) Container.DataItem) == true%>">
                                   <asp:PlaceHolder runat="server" Visible="<%# ((ResultDataItem)Container.DataItem).ItemIsRestricted == true && ((ResultDataItem)Container.DataItem).TemporarilyUnavailable == false  %>">
                                        <div title='<%# SessionObject.GetLanguageString("PACML_EBRESTRICTED_TIP")%>' data-item-id="RB<%# ((ResultDataItem)Container.DataItem).VendorObjectIdentifier != "" ? ((ResultDataItem)Container.DataItem).VendorObjectIdentifier : ((ResultDataItem) Container.DataItem).Position.ToString() %>" class="c-title-detail-actions__btn--restricted results-title-restricted-button ">
                                             <%# SessionObject.GetLanguageString("PACML_EBRESTRICTED")%>
                                        </div>
                                    </asp:PlaceHolder>
                                   <asp:PlaceHolder runat="server" Visible="<%# ((ResultDataItem)Container.DataItem).TemporarilyUnavailable == true %>">
                                        <div title='<%# SessionObject.GetLanguageString("PACML_EBNOTAVAIL_TIP")%>' data-item-id="RB<%# ((ResultDataItem)Container.DataItem).VendorObjectIdentifier != "" ? ((ResultDataItem)Container.DataItem).VendorObjectIdentifier : ((ResultDataItem) Container.DataItem).Position.ToString() %>" class="c-title-detail-actions__btn--restricted results-title-restricted-button ">
                                            <%# SessionObject.GetLanguageString("PACML_EBNOTAVAIL")%>
                                    </div>
                                   </asp:PlaceHolder>
                                    
                                   <asp:PlaceHolder runat="server" Visible="<%# ((ResultDataItem)Container.DataItem).ItemIsRestricted == false && ((ResultDataItem)Container.DataItem).TemporarilyUnavailable == false %>">
                                        <div class="RBdigitalVendorLinksWrapper" id="RBdigitalVendorLinksWrapperId-<%# ((ResultDataItem)Container.DataItem).VendorObjectIdentifier %>" data-item-id="<%# ((ResultDataItem)Container.DataItem).VendorObjectIdentifier %>">
                                          <asp:PlaceHolder runat="server" Visible="<%#!SessionObject.ModularPAC.Spoof %>">
                                            <div class="rbdigital-results-title-action-button rbdigital-results-title-action-button-primary" id="rbdigital-link-vendor-action<%# ((ResultDataItem)Container.DataItem).Position %>">
                                                <a class="c-title-detail-actions__btn rbdigital-link-nofancy <%# ((ResultDataItem)Container.DataItem).VendorObjectIdentifier %>" id="rbdigital-anchor-tag-<%# ((ResultDataItem)Container.DataItem).VendorObjectIdentifier %>" data-item-pos="<%# ((ResultDataItem)Container.DataItem).Position %>"  data-item-page="<%#  (((ResultDataItem)Container.DataItem).Position -1) / SessionObject.SearchManager.Input.SearchResultsPerPage %>"
                                                    href="<%# ((ResultDataItem)Container.DataItem).linkHref %>" data-link="<%# ((ResultDataItem)Container.DataItem).linkHref %>" data-link-rb="<%# PACPath.AsExternalUrl(PathType.PACRoot) + "search/components/ajaxRBdigitalRegistration.aspx?action=sbmt" %>" onclick='javascript:RBdigitalLinkClicked("<%#SessionObject.CurrentPatron.RBdigitalPatronID %>", "<%#SessionObject.CurrentPatron.IsSecured %>", "<%# ((ResultDataItem)Container.DataItem).VendorObjectIdentifier %>","<%# SessionObject.GetLanguageStringPlain("PACML_FUSION_LOGINREQUIRED") %>",event)'>
                                                    <span class="glyphicon glyphicon-plus" aria-hidden="true"></span>
                                                    <%# ((ResultDataItem)Container.DataItem).linkText%>                  
				                                </a>
                                            </div>
                                          </asp:PlaceHolder>                 
                                        </div>
                                  </asp:PlaceHolder>
                               </asp:PlaceHolder>
				           </li>
                           </asp:PlaceHolder>
                       </ul>
                       <div class="c-title-detail-actions__add-to-my-list dropdown--scroll-into-view">
                           <%-- Add to My List --%>
                           <% if (SessionObject.GetSearchCache().TitleListEnabled && !SessionObject.ModularPAC.Spoof)
                               { %>
                               <%# GetTitleListLink((ResultDataItem) Container.DataItem) %>
                           <% } %>
                       </div>
                    </div>
                </div>
            </div>
            <hr />
        </div> 
	</ItemTemplate>
</asp:Repeater>
</div>
<asp:PlaceHolder runat="server" Visible="<%# SessionObject.SearchManager.Results.PromotionsTable != null && SessionObject.SearchManager.Results.RowCount > 0 %>">
    <%# PACFunction.BuildFeatureItSearchDashboardBottom(SessionObject.SearchManager.Results.PromotionsTable, PromotionsLocation, SessionObject) %>  
</asp:PlaceHolder>

<Polaris:ResultsNavigation runat="server" PanelLocation="Bottom" Visible="<%# (SessionObject.SearchManager.Results.RowCount > 0) && !SessionObject.ModularPAC.Spoof %>" />

<asp:PlaceHolder runat="server" Visible="<%# SessionObject.SearchCache.GooglePreviewBriefEnabled == true && GooglePreviewISBNKeys.Length > 0 %>">
    <script src="<%#this.Request.IsSecureConnection ? "https":"http" %>://books.google.com/books?jscmd=viewapi&amp;bibkeys=<%# GooglePreviewISBNKeys %>&amp;callback=processDynamicLinksResponse"></script>
</asp:PlaceHolder>

<asp:PlaceHolder runat="server" Visible="<%# CloudLibrary3M.IsEnabled(SessionObject.OrgID) == true %>">

<div id="complete"></div>
</asp:PlaceHolder>
<script type="text/javascript" defer="defer">

    $(document).ready(function ($) {
        GetCloudLibraryPrivilegesWrapper("", false);
    });

    $(document).ready(function ($) {
        GetAxis360PrivilegesWrapper("", false);
    });
    $(document).ready(function ($) {
        GetOverdrivePrivilegesWrapper("", false);
    });

    $(document).ready(function ($) {
        GetRBdigitalPrivilegesWrapper("", false);

        var isPresent = document.getElementById('IsRBdigitalLicensedID');
        if (isPresent == null) {
            RemoveAvailabiltyForNotLicensed();
        }
    });

    $(document).ready(function ($) {
        GetRestrictedWrapper();
    });
   
    initializeBibliographicHover();



</script>