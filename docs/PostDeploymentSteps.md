# Post Deployment Steps

## Manage repositories
Link to the official documentation on GCP: [Connect to a GitHub repository](https://cloud.google.com/build/docs/automating-builds/github/connect-repo-github?generation=1st-gen)
***
> Connect the github repository to GCP:  
> 1. Cloud Build -> Triggers -> [\[MANAGE REPOSITORIES\]](https://console.cloud.google.com/cloud-build/triggers) -> \[CONNECT REPOSITORY\] -> Select source (Github) -> Authenticate -> Select reposirory -> \[CONNECT\]
>
![image](/docs/images/repositories_1.png)
***

## API Keys
Link to the official documentation on GCP: [Create an API key](https://cloud.google.com/docs/authentication/api-keys#create)
***
> ### This is the section if the \"Cloud Build Triggering\" API key does not exist ###
> Check API keys:  
> 1. Credentials -> [API keys](https://console.cloud.google.com/apis/credentials)
> 
![image](/docs/images/apikey_1.png)
> Create a new cloud build trigger:  
> 
> 2. Cloud build -> [Triggers](https://console.cloud.google.com/cloud-build/triggers) -> [CREATE TRIGGER]
> 
![image](/docs/images/apikey_2.png)
> Select the following options:  
> 
> 3. Choose Webhook URL -> Create new secret -> Show URL preview -> Close without save
>
![image](/docs/images/apikey_3.png)
>   
> Check again and make sure the API key was successfully generated:  
> 
> 4. Credentials -> [API keys](https://console.cloud.google.com/apis/credentials)
>
![image](/docs/images/apikey_4.png)
***

## OAuth consent screen
### Link to the official documentation on GCP: 
1. [Understanding brands and branding state](https://cloud.google.com/iap/docs/programmatic-oauth-clients#branding)
2. [Configure OAuth consent & register your app](https://developers.google.com/workspace/guides/configure-oauth-consent#configure_oauth_consent_register_your_app) 
***
> Create OAuth consent screen:  
> 1. APIs & Services -> [OAuth consent screen](https://console.cloud.google.com/apis/credentials/consent) -> External -> CREATE
>
![image](/docs/images/consent_1.png)
> Enter the app name and email addresses:
>
> 2. OAuth consent screen -> \[SAVE AND CONTINUE\]
>
![image](/docs/images/consent_2.png)
> Complete all tabs
>
> 3. Edit app registration -> OAuth consent screen -> Scopes -> Test users -> Summary -> \[BACK TO DASHBOARD\]
>
![image](/docs/images/consent_3.png)
***

## Credentials
Link to the official documentation on GCP: [Creating OAuth credentials](https://cloud.google.com/iap/docs/enabling-kubernetes-howto#oauth-credentials)
***
> Create:   
> 1. APIs & Services -> [Credentials](https://console.cloud.google.com/apis/credentials) -> \[CREATE CREDENTIALS\] -> OAuth client ID
>
![image](/docs/images/credentials_1.png)
> Select application type and enter name:
>   
> 2. Create OAuth client ID -> Web Application -> Name -> \[CREATE\]
>
![image](/docs/images/credentials_2.png)
> Prepare for the next step:
>   
> 3. Save the values
>
![image](/docs/images/credentials_3.png)
> Click the name of the client that you just created to reopen it for editing:
>   
> 4. In the Authorized redirect URIs field, enter the following string 
> ```https://iap.googleapis.com/v1/oauth/clientIds/CLIENT_ID:handleRedirect```  
>  where CLIENT_ID is the OAuth client ID you just copied to the clipboard.
>
![image](/docs/images/credentials_4.png)
> Update information in tfvars file:
> 
> 5. Uncomment the lines in the `tf/non-prod/iap/terraform.tfvars` file under "manually created iap client (optional)" and fill in the values  
> - CLIENT_ID in iap_client_id
> - Client secret in iap_client_secret
> 
> 
***
