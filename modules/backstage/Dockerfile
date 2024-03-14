FROM ghcr.io/backstage/backstage:1.13.2

USER root

RUN apt-get update && \
    apt-get install -y python3-pip && \
    pip install mkdocs==1.5.3 mkdocs-techdocs-core==1.2.3 && \
    apt-get clean && \
    rm -fr /var/lib/apt/lists/

USER node

RUN sed -i -e 's@"app": "link:../app",@"app": "file:../app",@' ./packages/backend/package.json && \
    npm i @backstage/plugin-cloudbuild@0.3.25 @backstage/plugin-techdocs@1.8.0

RUN mkdir -p /app/packages/app/src/components/Root/

COPY files/App.tsx /app/packages/app/src/App.tsx
COPY files/Root.tsx /app/packages/app/src/components/Root/Root.tsx
COPY files/plugins.ts /app/packages/app/src/plugins.ts
