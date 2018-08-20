JupyterHub (Keycloak Proxy)
===========================

This repository contains a sample application for deploying JupyterHub as a means to provide Jupyter notebooks to multiple users. Authentication of users is managed using the Keycloak auth proxy.

**Note: This sample application can only be deployed where secure routes in an OpenShift cluster with generated host names have signed certificates. You cannot use Minishift or ``oc cluster up``, which use self signed certificates.**

Deploying the application
-------------------------

To deploy the sample application, you can run:

```
oc new-app https://raw.githubusercontent.com/jupyter-on-openshift/poc-hub-keycloak-proxy/master/templates/jupyterhub.json
```

This will create all the required builds and deployments from the one template.

If desired, you can instead load the template, with instantiation of the template done as a separate step from the command line or using the OpenShift web console.

Resource requirements
---------------------

If deploying to an OpenShift environment that enforces quotas, you must have a memory quota for terminating workloads (pods) of 3GiB so that builds can be run. For one user, you will need 6GiB of quota for terminating workloads (pods). Each additional user requires 1GiB.

For storage, two 1GiB persistent volumes are required for the PostgreSQL databases for Keycloak and JupyterHub. Further, each user will need a 1GiB volume for notebook storage.

Registering a user
------------------

Keycloak will be deployed, with JupyterHub and Keycloak automatically configured to handle authentication of users. No users are setup in advance, but users can register themselves by clicking on the _Register_ link on the login page.
