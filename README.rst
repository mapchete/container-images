======================
Mapchete Container Images
======================

.. image:: https://github.com/mapchete/container-images/actions/workflows/build-image.yml/badge.svg
   :target: https://github.com/mapchete/container-images/actions/workflows/build-image.yml
   :alt: Build Status

.. image:: https://img.shields.io/github/license/mapchete/container-images
   :target: https://github.com/mapchete/container-images/blob/main/LICENSE
   :alt: MIT License

This repository builds and publishes a Docker container image for `Mapchete <https://github.com/mapchete/mapchete>`_ and its related extensions.

Available Image
---------------

The image is hosted on the GitHub Container Registry (ghcr.io).

mapchete
~~~~~~~~
The base image with a recent version of Mapchete including the ``mapchete-eo`` and ``mapchete-hub`` extensions.

.. code-block:: shell

   docker pull ghcr.io/mapchete/mapchete:latest


Automated Cleanup
-----------------

This repository uses an automated workflow to clean up old, untagged images. The following tags are always kept:

* ``latest``
* Version tags (e.g., ``1.2.3``)

All other images (i.e., those tagged with a commit SHA) are subject to cleanup to keep the registry tidy.
