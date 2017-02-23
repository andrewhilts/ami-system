#AMI CMS
The AMI CMS serves as the content repository for the AMI Frontend's primary functions. It manages the collections of jurisdictions, industries, data operators, data types, personal identifiers, and request letter templates that the AMI Frontend requests and packages into the simple request creation experience.

## Post Types
Each of the above mentioned collections are managed as custom Wordpress Post Types. The AMI CMS has the following custom post types:

*  Jurisdictions
*  Jurisdiction Links
*  Operator Industries
*  Request Templates
*  Operator Legal Statuses
*  Data Operator Services
*  Identifiers
*  Request Components
*  Data Banks
*  Data Operators

###Jurisdictions
Jurisdictions tie together data operators and request letter templates. They are very simple to create in the AMI CMS. Just add a new Jurisdiction and give it a name. 

The biggest trick is to notice the ID of the Jurisdiction you create. If you look in the URL of the jurisdiction you just created, you'll see `post=n`, where `n` is the ID of the jurisdiction. This is very important.

Jurisidictions are the first entry point into AMI. AMI Frontend has a configuration file that references the ID of the jurisdiction you want the frontend to target (see the AMI frontend section for more information). With that ID, AMI Frontend requests all the industries with data operators in the jurisdiction, to start the process.

###Jurisdiction Links
Jurisdiction links are basically blog post pages that are associated with a jurisdiction. The AMI Frontend requests all jurisdiction link for a given jurisdiction, and displays links to their content on the Frontend home page under the "For More Information" heading. This is a catch-all place to put in additional information about the law in a given jurisdiction, or an FAQ.

###Operator Industries
Operator industries are high-level categories for data operators to be grouped under. Request letters are written for operator industries. Operator industries have a name and a description that show up on the AMI Frontend homepage. The icon for an industry is managed in the AMI Frontend, where an icon file is created with the operator industry's post ID as its filename.

###Request Templates
Request Templates are the foundation of the requests that AMI generates. A request letter is written for each specific industry-jurisdiction relationship. For example, a request letter is needed for telecommunications companies in Canada, and a different one for telecommunications in Hong Kong, and a further different one for fitness trackers in Canada.

Here is an example request letter:

> [raw_html_snippet id="request_header"]

> Dear Privacy Officer:

> I am a user of your dating application, and am interested in both learning more about your data management practices and about the kinds of personal information that you maintain and retain about me. So this is a request to access my personal data under Principle 4.9 of Schedule 1 and section 8 of Canada’s federal privacy legislation, the Personal Information Protection and Electronic Documents Act (PIPEDA).

> I am, first of all, requesting more information about how data is collected and exchanged by you with other companies or organizations. Can you clarify whether my data, either in an individualized data set or part of an aggregate data set, has been provided to other parties? And if it has been provided (either voluntarily, as part of a commercial transaction, or on other grounds) please identify to which parties it has been provided.

> Second, I wanted to understand a bit more about how my data could be disclosed to government authorities. What are your specific policies, practices, or processes for handling requests from authorities from international jurisdictions, such as from Canadian policing organizations? How would you respond if my information was requested as evidence in a Canadian civil or criminal proceeding?

> Third, is the data transmitted between the application of yours that I have installed and your servers secured against potential eavesdroppers?

> [raw_html_snippet id="dataStart"]

> Finally, I am requesting a copy of all records which contain my personal information from your organization. The following is a non-exclusive listing of all information that [raw_html_snippet id="operator_name"] may hold about me, including the following:

> [raw_html_snippet id="data"]

> If your organization has other information in addition to these items, I formally request access to that as well. If your service includes a data export tool, please direct me to it, and ensure that in your response to this letter, you provide all information associated with me that is not included in the output of this tool. Please ensure that you include all information that is directly associated with my name, phone number, e-mail, or account number, as well as any other account identifiers that your company may associate with my personal information.

> You are obligated to provide copies at a free or minimal cost within thirty (30) days in receipt of this message. If you choose to deny this request, you must provide a valid reason for doing so under Canada's PIPEDA. Ignoring a written request is the same as refusing access. See the guide from the Office of the Privacy Commissioner at: http://www.priv.gc.ca/information/guide_e.asp#014. The Commissioner is an independent oversight body that handles privacy complaints from the public.

> Please let me know if your organization requires additional information from me before proceeding with my request.

> Here is information that may help you identify my records:

> [raw_html_snippet id="identifiers"]

> Sincerely,

> [raw_html_snippet id="request_footer"]

Note that the above letter has block sections referring to `raw_html_snippet`. These blocks represent areas where user input in the AMI Frontend is included in the request template to customize it. The snippets are all piece of AngularJS syntax that tell the AMI Frontend to put specific user input in place. The snippets are managed within WordPress in the "Settings > Raw HTML Snippets" menu area.

* `[raw_html_snippet id="request_header"]` refers to information that will be placed at the top of the request letter, like the address of a company's privacy officer, and the date.
* `[raw_html_snippet id="dataStart"]` starts a conditional block within the request letter, so that what immediately follows is only included if the user has selected data to request.
* `[raw_html_snippet id="data"]` refers to the specific data that a user has decided to request.
* `[raw_html_snippet id="identifiers"]` refers to the personal identifiers the requester has provided to help the data operator retrieve their records
* `[raw_html_snippet id="request_footer"]` refers to information that goes at the bottom of the request letter, such as the requester's name.

**Security Note: The request letter is parsed as an HTML template in Angular. In this regard, arbitrary HTML (Javascript is stripped) can be injected into the AMI Frontend using this method. Ensure that only trusted users have access to the AMI CMS and editor capabilties.**

In the Request Letter edit page, you must assign a jurisdiction, operator industry, and operator status to the letter.

###Operator Legal Statuses
Data operators can be assigned a legal status (eg commercial, non-profit) that you can manage here. This classification doesn't really do much currently.

###Data Operator Services
Data operator services are services that are offerend by data operators. They are an important under-the-hood part of AMI. Users don't really interact with services directly in the frontend. In an earlier incarnation of AMI, users could select individual services offered by a data operator, but to reduce complexity, we took out this step.

A data operator can be assigned one or more services. Services are generic things like "messaging app", "cellular telephony", etc. Services are associated with service "identifiers" that data operators use to identify subscribers to their services. They are also associated with types of personal data ("Request Components") that could be collected or used by a data operator when offering its service.

###Identifiers
Identifiers are pieces of data like "First name", "email address", "telephone number", and "username" that data operators use to identify users of their services. In AMI CMS, a data operator service associates itself with one or more identifiers.

Identifiers are presented as form fields in the AMI Frontend. In some cases, like "name", a user might need to type in some text. For other identifiers, like "Province", a user might select from a list of options. For this reason, each identifier in the AMI CMS has a form field type so that administrators can choose the best way for users to input their identifier.

Identifiers can also be marked as "basic personal information". This helps the AMI frontend intelligently group things like name and physical address together with things like username, that might be specific to a particular service.

###Request Components
Request components are the items that an AMI users asks for access to in their request. Request components can have types such as "data", "question", or "other". Currently, only the "data" type is actively used in AMI systems.

Request components consist of an internal title and a "component value" field. Component values are pieces of text describing the type of information that a user might request.

Data operator services are assigned a set of request components in order to provide AMI users with default options for data they can request from a dat aoperator.

###Data Banks
Data banks are specific to a particular industry -- the Canadian government. Data banks are the names and IDs of databases used by the Canadian federal government to store personal information.

They are used instead of services for requests to the Canadian government. Data operators can be specifically denoted as using data banks instead of services.

###Data Operators
Data operators represent a company or organization that AMI users can request data from. They have one or more jurisdictions, and one or more services. They also have a privacy contact with their email address and/or mailing address specified. They also have a logo, for which an image file can be uploaded within AMI CMS.

Data operators can be changed from having one or more services to having one or more data banks if the operator is a Canadian governmental entitity.

## Plugins used
This section describes the various plugins used by AMI CMS and the functionality they provide.

###Regenerate Thumbnails 
Used to regenerate image thumbnails for data operators or other posts if the thumbnail sizes are modified.

###Advanced Custom Fields
Allows for custom fields to be added to Wordpress posts. Enables different post types like data operator, jurisdiction, service identifiers, etc, to all have different custom fields for specific data attributes. This includes the powerful relation field type, that lets us link different posts together, such a linking a data operator to a jurisdiction, or a data operator service to one or many service identifiers.

###Advanced Custom Fields: qTranslate
This provides support for multilingual versions of the text data for advanced custom fields. This requires the advanced-custom-fields plugin as well as qtranslate-x.

###Custom Post Type UI
This plugin provides an admin interface for adding new post types and defining the data fields for each post type.

###qTranslate-X
This makes it easy to translate content into multiple languages. Lets you define the languages you support, and define how the URL structure for different language content works.

###Raw HTML Snippets
Lets you create snippets of HTML that can be included in posts by reference. This is used in AMI API to incorporate Angular syntax for including user-provided data into request letter templates.

###WP REST API
JSON-based REST API for Wordpress. This is used to set up API endpoints for accessing AMI CMS content in JSON. The AMI API plugin builds upon this plugin.

###W3 Total Cache
Helps to cache site content.

###Add Advance Custom Fields to JSON API
Empowers the JSON API plugin (WP REST API) to include advanced custom fields in the data it returns to API requests.

###AMI API
Adds custom endpoints to AMI CMS's REST API. Defines custom queries to return all industries for a given jurisdictions, all operators in a given jurisdiction along with their industries, all servide identifiers for a given operator, and more. 

See here for more information: https://github.com/andrewhilts/ami-api