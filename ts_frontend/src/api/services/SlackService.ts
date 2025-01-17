/* generated using openapi-typescript-codegen -- do not edit */
/* istanbul ignore file */
/* tslint:disable */
/* eslint-disable */
import type { CompositeChannelList } from '../models/CompositeChannelList';
import type { SubscribeChannelRequest } from '../models/SubscribeChannelRequest';
import type { SubscribedChannelList } from '../models/SubscribedChannelList';
import type { CancelablePromise } from '../core/CancelablePromise';
import { OpenAPI } from '../core/OpenAPI';
import { request as __request } from '../core/request';
export class SlackService {
    /**
     * Ch
     * @returns CompositeChannelList Get a list of public and subscribed channels
     * @throws ApiError
     */
    public static chChannelListGet(): CancelablePromise<CompositeChannelList> {
        return __request(OpenAPI, {
            method: 'GET',
            url: '/channel_list',
        });
    }
    /**
     * Subscribe Channel
     * @param requestBody
     * @returns SubscribedChannelList Successful Response
     * @throws ApiError
     */
    public static subscribeChannelSubscribeChannelPost(
        requestBody: SubscribeChannelRequest,
    ): CancelablePromise<SubscribedChannelList> {
        return __request(OpenAPI, {
            method: 'POST',
            url: '/subscribe_channel',
            body: requestBody,
            mediaType: 'application/json',
            errors: {
                422: `Validation Error`,
            },
        });
    }
    /**
     * Webhook Event
     * @returns any Successful Response
     * @throws ApiError
     */
    public static webhookEventWebhookEventPost(): CancelablePromise<any> {
        return __request(OpenAPI, {
            method: 'POST',
            url: '/webhook_event',
        });
    }
}
