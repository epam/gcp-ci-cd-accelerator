import { Routes, Route } from 'react-router';  
import { CloudbuildPage } from '@backstage/plugin-cloudbuild';  
  
const App = () => (  
  <Routes>  
    {/* Add other routes here */}  
    <Route path="/cloudbuild" element={<CloudbuildPage />} />  
  </Routes>  
);  
  
export default App;  
