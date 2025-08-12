======================
Mapchete Container Images
======================

.. image:: https://img.shields.io/github/v/release/mapchete/container-images
   :target: https://github.com/mapchete/container-images/releases
   :alt: Latest Release

.. image:: https://img.shields.io/github/actions/workflow/status/mapchete/container-images/build-image.yml
   :target: https://github.com/mapchete/container-images/actions/workflows/build-image.yml
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
The image is based on ``ghcr.io/osgeo/gdal:ubuntu-small-3.11.3`` (using Python ``3.12.3`` and GDAL ``3.11.3``) with the most recent versions of mapchete including the mapchete EO extension and mapchete Hub.

.. code-block:: shell

   docker pull ghcr.io/mapchete/mapchete:latest


Automated Cleanup
-----------------

This repository uses an automated workflow to clean up old, untagged images. The following tags are always kept:

* ``latest``
* Version tags (e.g., ``2025.8.0``)

All other images (i.e., those tagged with a commit SHA) are subject to cleanup to keep the registry tidy.
