/* generated using openapi-typescript-codegen -- do not edit */
/* istanbul ignore file */
/* tslint:disable */
/* eslint-disable */
import type { Body_Upload_Files_uploadFiles__post } from '../models/Body_Upload_Files_uploadFiles__post';
import type { FilesResponseModel } from '../models/FilesResponseModel';
import type { CancelablePromise } from '../core/CancelablePromise';
import { OpenAPI } from '../core/OpenAPI';
import { request as __request } from '../core/request';
export class StorageService {
    /**
     * Upload Files
     * @param formData
     * @returns FilesResponseModel Returns the uploaded file url
     * @throws ApiError
     */
    public static uploadFilesUploadFilesPost(
        formData: Body_Upload_Files_uploadFiles__post,
    ): CancelablePromise<FilesResponseModel> {
        return __request(OpenAPI, {
            method: 'POST',
            url: '/uploadFiles/',
            formData: formData,
            mediaType: 'multipart/form-data',
            errors: {
                422: `Validation Error`,
            },
        });
    }
}
