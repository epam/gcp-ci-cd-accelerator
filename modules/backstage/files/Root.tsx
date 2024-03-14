import { Sidebar, SidebarItem } from '@backstage/core';  
import { CloudBuildIcon } from '@backstage/plugin-cloudbuild';  
  
const Root = () => (  
  <Sidebar>  
    <SidebarItem icon={CloudBuildIcon} to="/cloudbuild" text="Cloud Build" />  
    {/* Add other side panel elements and related routes here */}  
  </Sidebar>  
);  
  
export default Root;  
