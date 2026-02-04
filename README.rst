======================
Mapchete Container Images
======================

.. image:: https://img.shields.io/github/v/release/mapchete/container-images
   :target: https://github.com/mapchete/container-images/releases
   :alt: Latest Release

.. image:: https://img.shields.io/github/actions/workflow/status/mapchete/container-images/build-controller.yml
   :target: https://github.com/mapchete/container-images/actions/workflows/build-controller.yml
   :alt: Build Status

.. image:: https://img.shields.io/github/license/mapchete/container-images
   :target: https://github.com/mapchete/container-images/blob/main/LICENSE
   :alt: MIT License

This repository builds and publishes a Docker container image for `mapchete <https://github.com/mapchete/mapchete>`_ and its related extensions.

Available Image
---------------

The image is hosted on the GitHub Container Registry (ghcr.io).

mapchete
~~~~~~~~
The image is based on ``ghcr.io/osgeo/gdal:ubuntu-small-3.12.0`` (using Python ``3.12.3`` and GDAL ``3.12.0``) with the most recent versions of mapchete including the mapchete EO extension and mapchete Hub.

.. code-block:: shell

   docker pull ghcr.io/mapchete/mapchete:latest


Automated Cleanup
-----------------

This repository uses an automated workflow to clean up old, untagged images. The following tags are always kept:

* ``latest``
* ``dev``
* Version tags (e.g., ``2025.8.1``)

All other images (i.e., those tagged with a commit SHA) are subject to cleanup to keep the registry tidy.


Build Control
-------------

Images can be manually rebuilt via the `build-controller <https://github.com/mapchete/container-images/actions/workflows/build-controller.yml>`_ workflow. This allows for manual triggers with custom tags and repository references.


Version Management
------------------

The default versions (branches, tags, or SHAs) for the dependent repositories are managed in the `versions.yml <versions.yml>`_ file.

.. code-block:: yaml

   MAPCHETE_REF_RELEASE: 2026.2.1
   MAPCHETE_EO_REF_RELEASE: 2026.2.0
   MAPCHETE_HUB_REF_RELEASE: 2025.11.0
   MAPCHETE_HUB_CLI_REF_RELEASE: 2025.9.0


   MAPCHETE_REF_ROLLING: main
   MAPCHETE_EO_REF_ROLLING: main
   MAPCHETE_HUB_REF_ROLLING: main
   MAPCHETE_HUB_CLI_REF_ROLLING: main


When creating a release tag in this repository, these versions are "frozen" for that specific image tag, ensuring reproducible builds.

