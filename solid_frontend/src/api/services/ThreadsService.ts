/* generated using openapi-typescript-codegen -- do not edit */
/* istanbul ignore file */
/* tslint:disable */
/* eslint-disable */
import type { MessageResponse } from '../models/MessageResponse';
import type { MessagesResponse } from '../models/MessagesResponse';
import type { ThreadCreate } from '../models/ThreadCreate';
import type { ThreadResponse } from '../models/ThreadResponse';
import type { ThreadsResponse } from '../models/ThreadsResponse';
import type { UserResponse } from '../models/UserResponse';
import type { UsersResponse } from '../models/UsersResponse';
import type { CancelablePromise } from '../core/CancelablePromise';
import { OpenAPI } from '../core/OpenAPI';
import { request as __request } from '../core/request';
export class ThreadsService {
    /**
     * Create a new message in a thread
     * The api will create a new message in a thread and return the newly created message
     * @param threadId
     * @param text
     * @param image
     * @returns MessageResponse Newly created message
     * @throws ApiError
     */
    public static createMessage(
        threadId: string,
        text: string,
        image?: string,
    ): CancelablePromise<MessageResponse> {
        return __request(OpenAPI, {
            method: 'POST',
            url: '/message',
            query: {
                'thread_id': threadId,
                'text': text,
                'image': image,
            },
            errors: {
                422: `Validation Error`,
            },
        });
    }
    /**
     * Get all messages in a thread
     * The api will return all messages in a thread
     * @param threadId
     * @returns MessagesResponse List of messages in a thread
     * @throws ApiError
     */
    public static getMessages(
        threadId: string,
    ): CancelablePromise<MessagesResponse> {
        return __request(OpenAPI, {
            method: 'GET',
            url: '/messages',
            query: {
                'thread_id': threadId,
            },
            errors: {
                422: `Validation Error`,
            },
        });
    }
    /**
     * Search threads in plain english and get top 3 matching threads
     * The api will return top 3 threads matching the query
     * @param query
     * @returns ThreadsResponse Successful Response
     * @throws ApiError
     */
    public static searchThreads(
        query: string,
    ): CancelablePromise<ThreadsResponse> {
        return __request(OpenAPI, {
            method: 'GET',
            url: '/searchThreads',
            query: {
                'query': query,
            },
            errors: {
                422: `Validation Error`,
            },
        });
    }
    /**
     * Create a new thread
     * The api will create a new thread and return the newly created thread
     * @param requestBody
     * @returns ThreadResponse Newly created thread
     * @throws ApiError
     */
    public static createThread(
        requestBody: ThreadCreate,
    ): CancelablePromise<ThreadResponse> {
        return __request(OpenAPI, {
            method: 'POST',
            url: '/thread',
            body: requestBody,
            mediaType: 'application/json',
            errors: {
                422: `Validation Error`,
            },
        });
    }
    /**
     * Get all threads
     * The api will return all threads
     * @returns ThreadsResponse List of threads
     * @throws ApiError
     */
    public static getThreads(): CancelablePromise<ThreadsResponse> {
        return __request(OpenAPI, {
            method: 'GET',
            url: '/threads',
        });
    }
    /**
     * Get user information
     * The api will return user information
     * @param userId
     * @returns UserResponse Successful Response
     * @throws ApiError
     */
    public static getUser(
        userId: string,
    ): CancelablePromise<UserResponse> {
        return __request(OpenAPI, {
            method: 'GET',
            url: '/user',
            query: {
                'user_id': userId,
            },
            errors: {
                422: `Validation Error`,
            },
        });
    }
    /**
     * Get all users
     * The api will return all users
     * @returns UsersResponse Successful Response
     * @throws ApiError
     */
    public static getUsers(): CancelablePromise<UsersResponse> {
        return __request(OpenAPI, {
            method: 'GET',
            url: '/users',
        });
    }
}
