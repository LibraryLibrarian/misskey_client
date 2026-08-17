// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'misskey_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MisskeyUser {

 String get id; String get username; String? get name; String? get host; String? get avatarUrl; String? get avatarBlurhash; bool? get isBot; bool? get isCat; Map<String, String>? get emojis; MisskeyOnlineStatus? get onlineStatus; DateTime? get createdAt; String? get description; int? get followersCount; int? get followingCount; int? get notesCount; bool? get isLocked; bool? get isSuspended; bool? get isSilenced; List<String>? get pinnedNoteIds; List<MisskeyNote>? get pinnedNotes; String? get bannerUrl; String? get bannerBlurhash; List<MisskeyUserField>? get fields; bool? get isFollowing; bool? get isFollowed; bool? get hasPendingFollowRequestFromYou; bool? get hasPendingFollowRequestToYou; bool? get isBlocking; bool? get isBlocked; bool? get isMuted; bool? get isRenoteMuted; List<MisskeyAvatarDecoration>? get avatarDecorations; bool? get requireSigninToViewContents; int? get makeNotesFollowersOnlyBefore; int? get makeNotesHiddenBefore; MisskeyUserInstance? get instance; List<MisskeyBadgeRole>? get badgeRoles; String? get url; String? get uri; String? get movedTo; List<String>? get alsoKnownAs; DateTime? get updatedAt; DateTime? get lastFetchedAt; String? get location; String? get birthday; String? get lang; List<String>? get verifiedLinks; bool? get publicReactions; String? get followingVisibility; String? get followersVisibility; List<MisskeyRoleLite>? get roles; String? get memo; String? get notify; bool? get withReplies; bool? get twoFactorEnabled; bool? get usePasswordLessLogin; bool? get securityKeys; bool? get isAdmin; bool? get isModerator; String? get pinnedPageId; String? get avatarId; String? get bannerId; String? get followedMessage; bool? get noCrawle; bool? get preventAiLearning; bool? get hideOnlineStatus; bool? get isExplorable; bool? get isDeleted; bool? get injectFeaturedNote; bool? get receiveAnnouncementEmail; bool? get alwaysMarkNsfw; bool? get autoSensitive; bool? get carefulBot; bool? get autoAcceptFollowed; String? get chatScope; bool? get canChat; bool? get hasUnreadSpecifiedNotes; bool? get hasUnreadMentions; bool? get hasUnreadChatMessages; bool? get hasUnreadAnnouncement; bool? get hasUnreadAntenna; bool? get hasUnreadChannel; bool? get hasUnreadNotification; bool? get hasPendingReceivedFollowRequest; int? get unreadNotificationsCount; List<MutedWord>? get mutedWords; List<MutedWord>? get hardMutedWords; List<String>? get mutedInstances; List<String>? get mutingNotificationTypes; Map<String, dynamic>? get notificationRecieveConfig; List<String>? get emailNotificationTypes; List<Map<String, dynamic>>? get achievements; int? get loggedInDays; Map<String, dynamic>? get policies; String? get twoFactorBackupCodesStock; String? get email; bool? get emailVerified; String? get moderationNote; bool? get isLimited; List<Map<String, dynamic>>? get mutualLinkSections; Map<String, dynamic>? get pinnedPage;
/// Create a copy of MisskeyUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyUserCopyWith<MisskeyUser> get copyWith => _$MisskeyUserCopyWithImpl<MisskeyUser>(this as MisskeyUser, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyUser&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.name, name) || other.name == name)&&(identical(other.host, host) || other.host == host)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.avatarBlurhash, avatarBlurhash) || other.avatarBlurhash == avatarBlurhash)&&(identical(other.isBot, isBot) || other.isBot == isBot)&&(identical(other.isCat, isCat) || other.isCat == isCat)&&const DeepCollectionEquality().equals(other.emojis, emojis)&&(identical(other.onlineStatus, onlineStatus) || other.onlineStatus == onlineStatus)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.description, description) || other.description == description)&&(identical(other.followersCount, followersCount) || other.followersCount == followersCount)&&(identical(other.followingCount, followingCount) || other.followingCount == followingCount)&&(identical(other.notesCount, notesCount) || other.notesCount == notesCount)&&(identical(other.isLocked, isLocked) || other.isLocked == isLocked)&&(identical(other.isSuspended, isSuspended) || other.isSuspended == isSuspended)&&(identical(other.isSilenced, isSilenced) || other.isSilenced == isSilenced)&&const DeepCollectionEquality().equals(other.pinnedNoteIds, pinnedNoteIds)&&const DeepCollectionEquality().equals(other.pinnedNotes, pinnedNotes)&&(identical(other.bannerUrl, bannerUrl) || other.bannerUrl == bannerUrl)&&(identical(other.bannerBlurhash, bannerBlurhash) || other.bannerBlurhash == bannerBlurhash)&&const DeepCollectionEquality().equals(other.fields, fields)&&(identical(other.isFollowing, isFollowing) || other.isFollowing == isFollowing)&&(identical(other.isFollowed, isFollowed) || other.isFollowed == isFollowed)&&(identical(other.hasPendingFollowRequestFromYou, hasPendingFollowRequestFromYou) || other.hasPendingFollowRequestFromYou == hasPendingFollowRequestFromYou)&&(identical(other.hasPendingFollowRequestToYou, hasPendingFollowRequestToYou) || other.hasPendingFollowRequestToYou == hasPendingFollowRequestToYou)&&(identical(other.isBlocking, isBlocking) || other.isBlocking == isBlocking)&&(identical(other.isBlocked, isBlocked) || other.isBlocked == isBlocked)&&(identical(other.isMuted, isMuted) || other.isMuted == isMuted)&&(identical(other.isRenoteMuted, isRenoteMuted) || other.isRenoteMuted == isRenoteMuted)&&const DeepCollectionEquality().equals(other.avatarDecorations, avatarDecorations)&&(identical(other.requireSigninToViewContents, requireSigninToViewContents) || other.requireSigninToViewContents == requireSigninToViewContents)&&(identical(other.makeNotesFollowersOnlyBefore, makeNotesFollowersOnlyBefore) || other.makeNotesFollowersOnlyBefore == makeNotesFollowersOnlyBefore)&&(identical(other.makeNotesHiddenBefore, makeNotesHiddenBefore) || other.makeNotesHiddenBefore == makeNotesHiddenBefore)&&(identical(other.instance, instance) || other.instance == instance)&&const DeepCollectionEquality().equals(other.badgeRoles, badgeRoles)&&(identical(other.url, url) || other.url == url)&&(identical(other.uri, uri) || other.uri == uri)&&(identical(other.movedTo, movedTo) || other.movedTo == movedTo)&&const DeepCollectionEquality().equals(other.alsoKnownAs, alsoKnownAs)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.lastFetchedAt, lastFetchedAt) || other.lastFetchedAt == lastFetchedAt)&&(identical(other.location, location) || other.location == location)&&(identical(other.birthday, birthday) || other.birthday == birthday)&&(identical(other.lang, lang) || other.lang == lang)&&const DeepCollectionEquality().equals(other.verifiedLinks, verifiedLinks)&&(identical(other.publicReactions, publicReactions) || other.publicReactions == publicReactions)&&(identical(other.followingVisibility, followingVisibility) || other.followingVisibility == followingVisibility)&&(identical(other.followersVisibility, followersVisibility) || other.followersVisibility == followersVisibility)&&const DeepCollectionEquality().equals(other.roles, roles)&&(identical(other.memo, memo) || other.memo == memo)&&(identical(other.notify, notify) || other.notify == notify)&&(identical(other.withReplies, withReplies) || other.withReplies == withReplies)&&(identical(other.twoFactorEnabled, twoFactorEnabled) || other.twoFactorEnabled == twoFactorEnabled)&&(identical(other.usePasswordLessLogin, usePasswordLessLogin) || other.usePasswordLessLogin == usePasswordLessLogin)&&(identical(other.securityKeys, securityKeys) || other.securityKeys == securityKeys)&&(identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin)&&(identical(other.isModerator, isModerator) || other.isModerator == isModerator)&&(identical(other.pinnedPageId, pinnedPageId) || other.pinnedPageId == pinnedPageId)&&(identical(other.avatarId, avatarId) || other.avatarId == avatarId)&&(identical(other.bannerId, bannerId) || other.bannerId == bannerId)&&(identical(other.followedMessage, followedMessage) || other.followedMessage == followedMessage)&&(identical(other.noCrawle, noCrawle) || other.noCrawle == noCrawle)&&(identical(other.preventAiLearning, preventAiLearning) || other.preventAiLearning == preventAiLearning)&&(identical(other.hideOnlineStatus, hideOnlineStatus) || other.hideOnlineStatus == hideOnlineStatus)&&(identical(other.isExplorable, isExplorable) || other.isExplorable == isExplorable)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.injectFeaturedNote, injectFeaturedNote) || other.injectFeaturedNote == injectFeaturedNote)&&(identical(other.receiveAnnouncementEmail, receiveAnnouncementEmail) || other.receiveAnnouncementEmail == receiveAnnouncementEmail)&&(identical(other.alwaysMarkNsfw, alwaysMarkNsfw) || other.alwaysMarkNsfw == alwaysMarkNsfw)&&(identical(other.autoSensitive, autoSensitive) || other.autoSensitive == autoSensitive)&&(identical(other.carefulBot, carefulBot) || other.carefulBot == carefulBot)&&(identical(other.autoAcceptFollowed, autoAcceptFollowed) || other.autoAcceptFollowed == autoAcceptFollowed)&&(identical(other.chatScope, chatScope) || other.chatScope == chatScope)&&(identical(other.canChat, canChat) || other.canChat == canChat)&&(identical(other.hasUnreadSpecifiedNotes, hasUnreadSpecifiedNotes) || other.hasUnreadSpecifiedNotes == hasUnreadSpecifiedNotes)&&(identical(other.hasUnreadMentions, hasUnreadMentions) || other.hasUnreadMentions == hasUnreadMentions)&&(identical(other.hasUnreadChatMessages, hasUnreadChatMessages) || other.hasUnreadChatMessages == hasUnreadChatMessages)&&(identical(other.hasUnreadAnnouncement, hasUnreadAnnouncement) || other.hasUnreadAnnouncement == hasUnreadAnnouncement)&&(identical(other.hasUnreadAntenna, hasUnreadAntenna) || other.hasUnreadAntenna == hasUnreadAntenna)&&(identical(other.hasUnreadChannel, hasUnreadChannel) || other.hasUnreadChannel == hasUnreadChannel)&&(identical(other.hasUnreadNotification, hasUnreadNotification) || other.hasUnreadNotification == hasUnreadNotification)&&(identical(other.hasPendingReceivedFollowRequest, hasPendingReceivedFollowRequest) || other.hasPendingReceivedFollowRequest == hasPendingReceivedFollowRequest)&&(identical(other.unreadNotificationsCount, unreadNotificationsCount) || other.unreadNotificationsCount == unreadNotificationsCount)&&const DeepCollectionEquality().equals(other.mutedWords, mutedWords)&&const DeepCollectionEquality().equals(other.hardMutedWords, hardMutedWords)&&const DeepCollectionEquality().equals(other.mutedInstances, mutedInstances)&&const DeepCollectionEquality().equals(other.mutingNotificationTypes, mutingNotificationTypes)&&const DeepCollectionEquality().equals(other.notificationRecieveConfig, notificationRecieveConfig)&&const DeepCollectionEquality().equals(other.emailNotificationTypes, emailNotificationTypes)&&const DeepCollectionEquality().equals(other.achievements, achievements)&&(identical(other.loggedInDays, loggedInDays) || other.loggedInDays == loggedInDays)&&const DeepCollectionEquality().equals(other.policies, policies)&&(identical(other.twoFactorBackupCodesStock, twoFactorBackupCodesStock) || other.twoFactorBackupCodesStock == twoFactorBackupCodesStock)&&(identical(other.email, email) || other.email == email)&&(identical(other.emailVerified, emailVerified) || other.emailVerified == emailVerified)&&(identical(other.moderationNote, moderationNote) || other.moderationNote == moderationNote)&&(identical(other.isLimited, isLimited) || other.isLimited == isLimited)&&const DeepCollectionEquality().equals(other.mutualLinkSections, mutualLinkSections)&&const DeepCollectionEquality().equals(other.pinnedPage, pinnedPage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,username,name,host,avatarUrl,avatarBlurhash,isBot,isCat,const DeepCollectionEquality().hash(emojis),onlineStatus,createdAt,description,followersCount,followingCount,notesCount,isLocked,isSuspended,isSilenced,const DeepCollectionEquality().hash(pinnedNoteIds),const DeepCollectionEquality().hash(pinnedNotes),bannerUrl,bannerBlurhash,const DeepCollectionEquality().hash(fields),isFollowing,isFollowed,hasPendingFollowRequestFromYou,hasPendingFollowRequestToYou,isBlocking,isBlocked,isMuted,isRenoteMuted,const DeepCollectionEquality().hash(avatarDecorations),requireSigninToViewContents,makeNotesFollowersOnlyBefore,makeNotesHiddenBefore,instance,const DeepCollectionEquality().hash(badgeRoles),url,uri,movedTo,const DeepCollectionEquality().hash(alsoKnownAs),updatedAt,lastFetchedAt,location,birthday,lang,const DeepCollectionEquality().hash(verifiedLinks),publicReactions,followingVisibility,followersVisibility,const DeepCollectionEquality().hash(roles),memo,notify,withReplies,twoFactorEnabled,usePasswordLessLogin,securityKeys,isAdmin,isModerator,pinnedPageId,avatarId,bannerId,followedMessage,noCrawle,preventAiLearning,hideOnlineStatus,isExplorable,isDeleted,injectFeaturedNote,receiveAnnouncementEmail,alwaysMarkNsfw,autoSensitive,carefulBot,autoAcceptFollowed,chatScope,canChat,hasUnreadSpecifiedNotes,hasUnreadMentions,hasUnreadChatMessages,hasUnreadAnnouncement,hasUnreadAntenna,hasUnreadChannel,hasUnreadNotification,hasPendingReceivedFollowRequest,unreadNotificationsCount,const DeepCollectionEquality().hash(mutedWords),const DeepCollectionEquality().hash(hardMutedWords),const DeepCollectionEquality().hash(mutedInstances),const DeepCollectionEquality().hash(mutingNotificationTypes),const DeepCollectionEquality().hash(notificationRecieveConfig),const DeepCollectionEquality().hash(emailNotificationTypes),const DeepCollectionEquality().hash(achievements),loggedInDays,const DeepCollectionEquality().hash(policies),twoFactorBackupCodesStock,email,emailVerified,moderationNote,isLimited,const DeepCollectionEquality().hash(mutualLinkSections),const DeepCollectionEquality().hash(pinnedPage)]);

@override
String toString() {
  return 'MisskeyUser(id: $id, username: $username, name: $name, host: $host, avatarUrl: $avatarUrl, avatarBlurhash: $avatarBlurhash, isBot: $isBot, isCat: $isCat, emojis: $emojis, onlineStatus: $onlineStatus, createdAt: $createdAt, description: $description, followersCount: $followersCount, followingCount: $followingCount, notesCount: $notesCount, isLocked: $isLocked, isSuspended: $isSuspended, isSilenced: $isSilenced, pinnedNoteIds: $pinnedNoteIds, pinnedNotes: $pinnedNotes, bannerUrl: $bannerUrl, bannerBlurhash: $bannerBlurhash, fields: $fields, isFollowing: $isFollowing, isFollowed: $isFollowed, hasPendingFollowRequestFromYou: $hasPendingFollowRequestFromYou, hasPendingFollowRequestToYou: $hasPendingFollowRequestToYou, isBlocking: $isBlocking, isBlocked: $isBlocked, isMuted: $isMuted, isRenoteMuted: $isRenoteMuted, avatarDecorations: $avatarDecorations, requireSigninToViewContents: $requireSigninToViewContents, makeNotesFollowersOnlyBefore: $makeNotesFollowersOnlyBefore, makeNotesHiddenBefore: $makeNotesHiddenBefore, instance: $instance, badgeRoles: $badgeRoles, url: $url, uri: $uri, movedTo: $movedTo, alsoKnownAs: $alsoKnownAs, updatedAt: $updatedAt, lastFetchedAt: $lastFetchedAt, location: $location, birthday: $birthday, lang: $lang, verifiedLinks: $verifiedLinks, publicReactions: $publicReactions, followingVisibility: $followingVisibility, followersVisibility: $followersVisibility, roles: $roles, memo: $memo, notify: $notify, withReplies: $withReplies, twoFactorEnabled: $twoFactorEnabled, usePasswordLessLogin: $usePasswordLessLogin, securityKeys: $securityKeys, isAdmin: $isAdmin, isModerator: $isModerator, pinnedPageId: $pinnedPageId, avatarId: $avatarId, bannerId: $bannerId, followedMessage: $followedMessage, noCrawle: $noCrawle, preventAiLearning: $preventAiLearning, hideOnlineStatus: $hideOnlineStatus, isExplorable: $isExplorable, isDeleted: $isDeleted, injectFeaturedNote: $injectFeaturedNote, receiveAnnouncementEmail: $receiveAnnouncementEmail, alwaysMarkNsfw: $alwaysMarkNsfw, autoSensitive: $autoSensitive, carefulBot: $carefulBot, autoAcceptFollowed: $autoAcceptFollowed, chatScope: $chatScope, canChat: $canChat, hasUnreadSpecifiedNotes: $hasUnreadSpecifiedNotes, hasUnreadMentions: $hasUnreadMentions, hasUnreadChatMessages: $hasUnreadChatMessages, hasUnreadAnnouncement: $hasUnreadAnnouncement, hasUnreadAntenna: $hasUnreadAntenna, hasUnreadChannel: $hasUnreadChannel, hasUnreadNotification: $hasUnreadNotification, hasPendingReceivedFollowRequest: $hasPendingReceivedFollowRequest, unreadNotificationsCount: $unreadNotificationsCount, mutedWords: $mutedWords, hardMutedWords: $hardMutedWords, mutedInstances: $mutedInstances, mutingNotificationTypes: $mutingNotificationTypes, notificationRecieveConfig: $notificationRecieveConfig, emailNotificationTypes: $emailNotificationTypes, achievements: $achievements, loggedInDays: $loggedInDays, policies: $policies, twoFactorBackupCodesStock: $twoFactorBackupCodesStock, email: $email, emailVerified: $emailVerified, moderationNote: $moderationNote, isLimited: $isLimited, mutualLinkSections: $mutualLinkSections, pinnedPage: $pinnedPage)';
}


}

/// @nodoc
abstract mixin class $MisskeyUserCopyWith<$Res>  {
  factory $MisskeyUserCopyWith(MisskeyUser value, $Res Function(MisskeyUser) _then) = _$MisskeyUserCopyWithImpl;
@useResult
$Res call({
 String id, String username, String? name, String? host, String? avatarUrl, String? avatarBlurhash, bool? isBot, bool? isCat, Map<String, String>? emojis, MisskeyOnlineStatus? onlineStatus, DateTime? createdAt, String? description, int? followersCount, int? followingCount, int? notesCount, bool? isLocked, bool? isSuspended, bool? isSilenced, List<String>? pinnedNoteIds, List<MisskeyNote>? pinnedNotes, String? bannerUrl, String? bannerBlurhash, List<MisskeyUserField>? fields, bool? isFollowing, bool? isFollowed, bool? hasPendingFollowRequestFromYou, bool? hasPendingFollowRequestToYou, bool? isBlocking, bool? isBlocked, bool? isMuted, bool? isRenoteMuted, List<MisskeyAvatarDecoration>? avatarDecorations, bool? requireSigninToViewContents, int? makeNotesFollowersOnlyBefore, int? makeNotesHiddenBefore, MisskeyUserInstance? instance, List<MisskeyBadgeRole>? badgeRoles, String? url, String? uri, String? movedTo, List<String>? alsoKnownAs, DateTime? updatedAt, DateTime? lastFetchedAt, String? location, String? birthday, String? lang, List<String>? verifiedLinks, bool? publicReactions, String? followingVisibility, String? followersVisibility, List<MisskeyRoleLite>? roles, String? memo, String? notify, bool? withReplies, bool? twoFactorEnabled, bool? usePasswordLessLogin, bool? securityKeys, bool? isAdmin, bool? isModerator, String? pinnedPageId, String? avatarId, String? bannerId, String? followedMessage, bool? noCrawle, bool? preventAiLearning, bool? hideOnlineStatus, bool? isExplorable, bool? isDeleted, bool? injectFeaturedNote, bool? receiveAnnouncementEmail, bool? alwaysMarkNsfw, bool? autoSensitive, bool? carefulBot, bool? autoAcceptFollowed, String? chatScope, bool? canChat, bool? hasUnreadSpecifiedNotes, bool? hasUnreadMentions, bool? hasUnreadChatMessages, bool? hasUnreadAnnouncement, bool? hasUnreadAntenna, bool? hasUnreadChannel, bool? hasUnreadNotification, bool? hasPendingReceivedFollowRequest, int? unreadNotificationsCount, List<MutedWord>? mutedWords, List<MutedWord>? hardMutedWords, List<String>? mutedInstances, List<String>? mutingNotificationTypes, Map<String, dynamic>? notificationRecieveConfig, List<String>? emailNotificationTypes, List<Map<String, dynamic>>? achievements, int? loggedInDays, Map<String, dynamic>? policies, String? twoFactorBackupCodesStock, String? email, bool? emailVerified, String? moderationNote, bool? isLimited, List<Map<String, dynamic>>? mutualLinkSections, Map<String, dynamic>? pinnedPage
});




}
/// @nodoc
class _$MisskeyUserCopyWithImpl<$Res>
    implements $MisskeyUserCopyWith<$Res> {
  _$MisskeyUserCopyWithImpl(this._self, this._then);

  final MisskeyUser _self;
  final $Res Function(MisskeyUser) _then;

/// Create a copy of MisskeyUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? name = freezed,Object? host = freezed,Object? avatarUrl = freezed,Object? avatarBlurhash = freezed,Object? isBot = freezed,Object? isCat = freezed,Object? emojis = freezed,Object? onlineStatus = freezed,Object? createdAt = freezed,Object? description = freezed,Object? followersCount = freezed,Object? followingCount = freezed,Object? notesCount = freezed,Object? isLocked = freezed,Object? isSuspended = freezed,Object? isSilenced = freezed,Object? pinnedNoteIds = freezed,Object? pinnedNotes = freezed,Object? bannerUrl = freezed,Object? bannerBlurhash = freezed,Object? fields = freezed,Object? isFollowing = freezed,Object? isFollowed = freezed,Object? hasPendingFollowRequestFromYou = freezed,Object? hasPendingFollowRequestToYou = freezed,Object? isBlocking = freezed,Object? isBlocked = freezed,Object? isMuted = freezed,Object? isRenoteMuted = freezed,Object? avatarDecorations = freezed,Object? requireSigninToViewContents = freezed,Object? makeNotesFollowersOnlyBefore = freezed,Object? makeNotesHiddenBefore = freezed,Object? instance = freezed,Object? badgeRoles = freezed,Object? url = freezed,Object? uri = freezed,Object? movedTo = freezed,Object? alsoKnownAs = freezed,Object? updatedAt = freezed,Object? lastFetchedAt = freezed,Object? location = freezed,Object? birthday = freezed,Object? lang = freezed,Object? verifiedLinks = freezed,Object? publicReactions = freezed,Object? followingVisibility = freezed,Object? followersVisibility = freezed,Object? roles = freezed,Object? memo = freezed,Object? notify = freezed,Object? withReplies = freezed,Object? twoFactorEnabled = freezed,Object? usePasswordLessLogin = freezed,Object? securityKeys = freezed,Object? isAdmin = freezed,Object? isModerator = freezed,Object? pinnedPageId = freezed,Object? avatarId = freezed,Object? bannerId = freezed,Object? followedMessage = freezed,Object? noCrawle = freezed,Object? preventAiLearning = freezed,Object? hideOnlineStatus = freezed,Object? isExplorable = freezed,Object? isDeleted = freezed,Object? injectFeaturedNote = freezed,Object? receiveAnnouncementEmail = freezed,Object? alwaysMarkNsfw = freezed,Object? autoSensitive = freezed,Object? carefulBot = freezed,Object? autoAcceptFollowed = freezed,Object? chatScope = freezed,Object? canChat = freezed,Object? hasUnreadSpecifiedNotes = freezed,Object? hasUnreadMentions = freezed,Object? hasUnreadChatMessages = freezed,Object? hasUnreadAnnouncement = freezed,Object? hasUnreadAntenna = freezed,Object? hasUnreadChannel = freezed,Object? hasUnreadNotification = freezed,Object? hasPendingReceivedFollowRequest = freezed,Object? unreadNotificationsCount = freezed,Object? mutedWords = freezed,Object? hardMutedWords = freezed,Object? mutedInstances = freezed,Object? mutingNotificationTypes = freezed,Object? notificationRecieveConfig = freezed,Object? emailNotificationTypes = freezed,Object? achievements = freezed,Object? loggedInDays = freezed,Object? policies = freezed,Object? twoFactorBackupCodesStock = freezed,Object? email = freezed,Object? emailVerified = freezed,Object? moderationNote = freezed,Object? isLimited = freezed,Object? mutualLinkSections = freezed,Object? pinnedPage = freezed,}) {
  return _then(MisskeyUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,host: freezed == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,avatarBlurhash: freezed == avatarBlurhash ? _self.avatarBlurhash : avatarBlurhash // ignore: cast_nullable_to_non_nullable
as String?,isBot: freezed == isBot ? _self.isBot : isBot // ignore: cast_nullable_to_non_nullable
as bool?,isCat: freezed == isCat ? _self.isCat : isCat // ignore: cast_nullable_to_non_nullable
as bool?,emojis: freezed == emojis ? _self.emojis : emojis // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,onlineStatus: freezed == onlineStatus ? _self.onlineStatus : onlineStatus // ignore: cast_nullable_to_non_nullable
as MisskeyOnlineStatus?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,followersCount: freezed == followersCount ? _self.followersCount : followersCount // ignore: cast_nullable_to_non_nullable
as int?,followingCount: freezed == followingCount ? _self.followingCount : followingCount // ignore: cast_nullable_to_non_nullable
as int?,notesCount: freezed == notesCount ? _self.notesCount : notesCount // ignore: cast_nullable_to_non_nullable
as int?,isLocked: freezed == isLocked ? _self.isLocked : isLocked // ignore: cast_nullable_to_non_nullable
as bool?,isSuspended: freezed == isSuspended ? _self.isSuspended : isSuspended // ignore: cast_nullable_to_non_nullable
as bool?,isSilenced: freezed == isSilenced ? _self.isSilenced : isSilenced // ignore: cast_nullable_to_non_nullable
as bool?,pinnedNoteIds: freezed == pinnedNoteIds ? _self.pinnedNoteIds : pinnedNoteIds // ignore: cast_nullable_to_non_nullable
as List<String>?,pinnedNotes: freezed == pinnedNotes ? _self.pinnedNotes : pinnedNotes // ignore: cast_nullable_to_non_nullable
as List<MisskeyNote>?,bannerUrl: freezed == bannerUrl ? _self.bannerUrl : bannerUrl // ignore: cast_nullable_to_non_nullable
as String?,bannerBlurhash: freezed == bannerBlurhash ? _self.bannerBlurhash : bannerBlurhash // ignore: cast_nullable_to_non_nullable
as String?,fields: freezed == fields ? _self.fields : fields // ignore: cast_nullable_to_non_nullable
as List<MisskeyUserField>?,isFollowing: freezed == isFollowing ? _self.isFollowing : isFollowing // ignore: cast_nullable_to_non_nullable
as bool?,isFollowed: freezed == isFollowed ? _self.isFollowed : isFollowed // ignore: cast_nullable_to_non_nullable
as bool?,hasPendingFollowRequestFromYou: freezed == hasPendingFollowRequestFromYou ? _self.hasPendingFollowRequestFromYou : hasPendingFollowRequestFromYou // ignore: cast_nullable_to_non_nullable
as bool?,hasPendingFollowRequestToYou: freezed == hasPendingFollowRequestToYou ? _self.hasPendingFollowRequestToYou : hasPendingFollowRequestToYou // ignore: cast_nullable_to_non_nullable
as bool?,isBlocking: freezed == isBlocking ? _self.isBlocking : isBlocking // ignore: cast_nullable_to_non_nullable
as bool?,isBlocked: freezed == isBlocked ? _self.isBlocked : isBlocked // ignore: cast_nullable_to_non_nullable
as bool?,isMuted: freezed == isMuted ? _self.isMuted : isMuted // ignore: cast_nullable_to_non_nullable
as bool?,isRenoteMuted: freezed == isRenoteMuted ? _self.isRenoteMuted : isRenoteMuted // ignore: cast_nullable_to_non_nullable
as bool?,avatarDecorations: freezed == avatarDecorations ? _self.avatarDecorations : avatarDecorations // ignore: cast_nullable_to_non_nullable
as List<MisskeyAvatarDecoration>?,requireSigninToViewContents: freezed == requireSigninToViewContents ? _self.requireSigninToViewContents : requireSigninToViewContents // ignore: cast_nullable_to_non_nullable
as bool?,makeNotesFollowersOnlyBefore: freezed == makeNotesFollowersOnlyBefore ? _self.makeNotesFollowersOnlyBefore : makeNotesFollowersOnlyBefore // ignore: cast_nullable_to_non_nullable
as int?,makeNotesHiddenBefore: freezed == makeNotesHiddenBefore ? _self.makeNotesHiddenBefore : makeNotesHiddenBefore // ignore: cast_nullable_to_non_nullable
as int?,instance: freezed == instance ? _self.instance : instance // ignore: cast_nullable_to_non_nullable
as MisskeyUserInstance?,badgeRoles: freezed == badgeRoles ? _self.badgeRoles : badgeRoles // ignore: cast_nullable_to_non_nullable
as List<MisskeyBadgeRole>?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,uri: freezed == uri ? _self.uri : uri // ignore: cast_nullable_to_non_nullable
as String?,movedTo: freezed == movedTo ? _self.movedTo : movedTo // ignore: cast_nullable_to_non_nullable
as String?,alsoKnownAs: freezed == alsoKnownAs ? _self.alsoKnownAs : alsoKnownAs // ignore: cast_nullable_to_non_nullable
as List<String>?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastFetchedAt: freezed == lastFetchedAt ? _self.lastFetchedAt : lastFetchedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,birthday: freezed == birthday ? _self.birthday : birthday // ignore: cast_nullable_to_non_nullable
as String?,lang: freezed == lang ? _self.lang : lang // ignore: cast_nullable_to_non_nullable
as String?,verifiedLinks: freezed == verifiedLinks ? _self.verifiedLinks : verifiedLinks // ignore: cast_nullable_to_non_nullable
as List<String>?,publicReactions: freezed == publicReactions ? _self.publicReactions : publicReactions // ignore: cast_nullable_to_non_nullable
as bool?,followingVisibility: freezed == followingVisibility ? _self.followingVisibility : followingVisibility // ignore: cast_nullable_to_non_nullable
as String?,followersVisibility: freezed == followersVisibility ? _self.followersVisibility : followersVisibility // ignore: cast_nullable_to_non_nullable
as String?,roles: freezed == roles ? _self.roles : roles // ignore: cast_nullable_to_non_nullable
as List<MisskeyRoleLite>?,memo: freezed == memo ? _self.memo : memo // ignore: cast_nullable_to_non_nullable
as String?,notify: freezed == notify ? _self.notify : notify // ignore: cast_nullable_to_non_nullable
as String?,withReplies: freezed == withReplies ? _self.withReplies : withReplies // ignore: cast_nullable_to_non_nullable
as bool?,twoFactorEnabled: freezed == twoFactorEnabled ? _self.twoFactorEnabled : twoFactorEnabled // ignore: cast_nullable_to_non_nullable
as bool?,usePasswordLessLogin: freezed == usePasswordLessLogin ? _self.usePasswordLessLogin : usePasswordLessLogin // ignore: cast_nullable_to_non_nullable
as bool?,securityKeys: freezed == securityKeys ? _self.securityKeys : securityKeys // ignore: cast_nullable_to_non_nullable
as bool?,isAdmin: freezed == isAdmin ? _self.isAdmin : isAdmin // ignore: cast_nullable_to_non_nullable
as bool?,isModerator: freezed == isModerator ? _self.isModerator : isModerator // ignore: cast_nullable_to_non_nullable
as bool?,pinnedPageId: freezed == pinnedPageId ? _self.pinnedPageId : pinnedPageId // ignore: cast_nullable_to_non_nullable
as String?,avatarId: freezed == avatarId ? _self.avatarId : avatarId // ignore: cast_nullable_to_non_nullable
as String?,bannerId: freezed == bannerId ? _self.bannerId : bannerId // ignore: cast_nullable_to_non_nullable
as String?,followedMessage: freezed == followedMessage ? _self.followedMessage : followedMessage // ignore: cast_nullable_to_non_nullable
as String?,noCrawle: freezed == noCrawle ? _self.noCrawle : noCrawle // ignore: cast_nullable_to_non_nullable
as bool?,preventAiLearning: freezed == preventAiLearning ? _self.preventAiLearning : preventAiLearning // ignore: cast_nullable_to_non_nullable
as bool?,hideOnlineStatus: freezed == hideOnlineStatus ? _self.hideOnlineStatus : hideOnlineStatus // ignore: cast_nullable_to_non_nullable
as bool?,isExplorable: freezed == isExplorable ? _self.isExplorable : isExplorable // ignore: cast_nullable_to_non_nullable
as bool?,isDeleted: freezed == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool?,injectFeaturedNote: freezed == injectFeaturedNote ? _self.injectFeaturedNote : injectFeaturedNote // ignore: cast_nullable_to_non_nullable
as bool?,receiveAnnouncementEmail: freezed == receiveAnnouncementEmail ? _self.receiveAnnouncementEmail : receiveAnnouncementEmail // ignore: cast_nullable_to_non_nullable
as bool?,alwaysMarkNsfw: freezed == alwaysMarkNsfw ? _self.alwaysMarkNsfw : alwaysMarkNsfw // ignore: cast_nullable_to_non_nullable
as bool?,autoSensitive: freezed == autoSensitive ? _self.autoSensitive : autoSensitive // ignore: cast_nullable_to_non_nullable
as bool?,carefulBot: freezed == carefulBot ? _self.carefulBot : carefulBot // ignore: cast_nullable_to_non_nullable
as bool?,autoAcceptFollowed: freezed == autoAcceptFollowed ? _self.autoAcceptFollowed : autoAcceptFollowed // ignore: cast_nullable_to_non_nullable
as bool?,chatScope: freezed == chatScope ? _self.chatScope : chatScope // ignore: cast_nullable_to_non_nullable
as String?,canChat: freezed == canChat ? _self.canChat : canChat // ignore: cast_nullable_to_non_nullable
as bool?,hasUnreadSpecifiedNotes: freezed == hasUnreadSpecifiedNotes ? _self.hasUnreadSpecifiedNotes : hasUnreadSpecifiedNotes // ignore: cast_nullable_to_non_nullable
as bool?,hasUnreadMentions: freezed == hasUnreadMentions ? _self.hasUnreadMentions : hasUnreadMentions // ignore: cast_nullable_to_non_nullable
as bool?,hasUnreadChatMessages: freezed == hasUnreadChatMessages ? _self.hasUnreadChatMessages : hasUnreadChatMessages // ignore: cast_nullable_to_non_nullable
as bool?,hasUnreadAnnouncement: freezed == hasUnreadAnnouncement ? _self.hasUnreadAnnouncement : hasUnreadAnnouncement // ignore: cast_nullable_to_non_nullable
as bool?,hasUnreadAntenna: freezed == hasUnreadAntenna ? _self.hasUnreadAntenna : hasUnreadAntenna // ignore: cast_nullable_to_non_nullable
as bool?,hasUnreadChannel: freezed == hasUnreadChannel ? _self.hasUnreadChannel : hasUnreadChannel // ignore: cast_nullable_to_non_nullable
as bool?,hasUnreadNotification: freezed == hasUnreadNotification ? _self.hasUnreadNotification : hasUnreadNotification // ignore: cast_nullable_to_non_nullable
as bool?,hasPendingReceivedFollowRequest: freezed == hasPendingReceivedFollowRequest ? _self.hasPendingReceivedFollowRequest : hasPendingReceivedFollowRequest // ignore: cast_nullable_to_non_nullable
as bool?,unreadNotificationsCount: freezed == unreadNotificationsCount ? _self.unreadNotificationsCount : unreadNotificationsCount // ignore: cast_nullable_to_non_nullable
as int?,mutedWords: freezed == mutedWords ? _self.mutedWords : mutedWords // ignore: cast_nullable_to_non_nullable
as List<MutedWord>?,hardMutedWords: freezed == hardMutedWords ? _self.hardMutedWords : hardMutedWords // ignore: cast_nullable_to_non_nullable
as List<MutedWord>?,mutedInstances: freezed == mutedInstances ? _self.mutedInstances : mutedInstances // ignore: cast_nullable_to_non_nullable
as List<String>?,mutingNotificationTypes: freezed == mutingNotificationTypes ? _self.mutingNotificationTypes : mutingNotificationTypes // ignore: cast_nullable_to_non_nullable
as List<String>?,notificationRecieveConfig: freezed == notificationRecieveConfig ? _self.notificationRecieveConfig : notificationRecieveConfig // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,emailNotificationTypes: freezed == emailNotificationTypes ? _self.emailNotificationTypes : emailNotificationTypes // ignore: cast_nullable_to_non_nullable
as List<String>?,achievements: freezed == achievements ? _self.achievements : achievements // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>?,loggedInDays: freezed == loggedInDays ? _self.loggedInDays : loggedInDays // ignore: cast_nullable_to_non_nullable
as int?,policies: freezed == policies ? _self.policies : policies // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,twoFactorBackupCodesStock: freezed == twoFactorBackupCodesStock ? _self.twoFactorBackupCodesStock : twoFactorBackupCodesStock // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,emailVerified: freezed == emailVerified ? _self.emailVerified : emailVerified // ignore: cast_nullable_to_non_nullable
as bool?,moderationNote: freezed == moderationNote ? _self.moderationNote : moderationNote // ignore: cast_nullable_to_non_nullable
as String?,isLimited: freezed == isLimited ? _self.isLimited : isLimited // ignore: cast_nullable_to_non_nullable
as bool?,mutualLinkSections: freezed == mutualLinkSections ? _self.mutualLinkSections : mutualLinkSections // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>?,pinnedPage: freezed == pinnedPage ? _self.pinnedPage : pinnedPage // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyUser].
extension MisskeyUserPatterns on MisskeyUser {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({required TResult orElse(),}){
final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({required TResult orElse(),}) {final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  return null;

}
}

}


/// @nodoc
mixin _$MisskeyUserField {

 String get name; String get value;
/// Create a copy of MisskeyUserField
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyUserFieldCopyWith<MisskeyUserField> get copyWith => _$MisskeyUserFieldCopyWithImpl<MisskeyUserField>(this as MisskeyUserField, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyUserField&&(identical(other.name, name) || other.name == name)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,value);

@override
String toString() {
  return 'MisskeyUserField(name: $name, value: $value)';
}


}

/// @nodoc
abstract mixin class $MisskeyUserFieldCopyWith<$Res>  {
  factory $MisskeyUserFieldCopyWith(MisskeyUserField value, $Res Function(MisskeyUserField) _then) = _$MisskeyUserFieldCopyWithImpl;
@useResult
$Res call({
 String name, String value
});




}
/// @nodoc
class _$MisskeyUserFieldCopyWithImpl<$Res>
    implements $MisskeyUserFieldCopyWith<$Res> {
  _$MisskeyUserFieldCopyWithImpl(this._self, this._then);

  final MisskeyUserField _self;
  final $Res Function(MisskeyUserField) _then;

/// Create a copy of MisskeyUserField
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? value = null,}) {
  return _then(MisskeyUserField(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyUserField].
extension MisskeyUserFieldPatterns on MisskeyUserField {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({required TResult orElse(),}){
final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({required TResult orElse(),}) {final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  return null;

}
}

}


/// @nodoc
mixin _$MisskeyAvatarDecoration {

 String get id; double? get angle; bool? get flipH; String get url; double? get offsetX; double? get offsetY;
/// Create a copy of MisskeyAvatarDecoration
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyAvatarDecorationCopyWith<MisskeyAvatarDecoration> get copyWith => _$MisskeyAvatarDecorationCopyWithImpl<MisskeyAvatarDecoration>(this as MisskeyAvatarDecoration, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyAvatarDecoration&&(identical(other.id, id) || other.id == id)&&(identical(other.angle, angle) || other.angle == angle)&&(identical(other.flipH, flipH) || other.flipH == flipH)&&(identical(other.url, url) || other.url == url)&&(identical(other.offsetX, offsetX) || other.offsetX == offsetX)&&(identical(other.offsetY, offsetY) || other.offsetY == offsetY));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,angle,flipH,url,offsetX,offsetY);

@override
String toString() {
  return 'MisskeyAvatarDecoration(id: $id, angle: $angle, flipH: $flipH, url: $url, offsetX: $offsetX, offsetY: $offsetY)';
}


}

/// @nodoc
abstract mixin class $MisskeyAvatarDecorationCopyWith<$Res>  {
  factory $MisskeyAvatarDecorationCopyWith(MisskeyAvatarDecoration value, $Res Function(MisskeyAvatarDecoration) _then) = _$MisskeyAvatarDecorationCopyWithImpl;
@useResult
$Res call({
 String id, double? angle, bool? flipH, String url, double? offsetX, double? offsetY
});




}
/// @nodoc
class _$MisskeyAvatarDecorationCopyWithImpl<$Res>
    implements $MisskeyAvatarDecorationCopyWith<$Res> {
  _$MisskeyAvatarDecorationCopyWithImpl(this._self, this._then);

  final MisskeyAvatarDecoration _self;
  final $Res Function(MisskeyAvatarDecoration) _then;

/// Create a copy of MisskeyAvatarDecoration
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? angle = freezed,Object? flipH = freezed,Object? url = null,Object? offsetX = freezed,Object? offsetY = freezed,}) {
  return _then(MisskeyAvatarDecoration(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,angle: freezed == angle ? _self.angle : angle // ignore: cast_nullable_to_non_nullable
as double?,flipH: freezed == flipH ? _self.flipH : flipH // ignore: cast_nullable_to_non_nullable
as bool?,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,offsetX: freezed == offsetX ? _self.offsetX : offsetX // ignore: cast_nullable_to_non_nullable
as double?,offsetY: freezed == offsetY ? _self.offsetY : offsetY // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyAvatarDecoration].
extension MisskeyAvatarDecorationPatterns on MisskeyAvatarDecoration {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({required TResult orElse(),}){
final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({required TResult orElse(),}) {final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  return null;

}
}

}


/// @nodoc
mixin _$MisskeyUserInstance {

 String? get name; String? get softwareName; String? get softwareVersion; String? get iconUrl; String? get faviconUrl; String? get themeColor;
/// Create a copy of MisskeyUserInstance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyUserInstanceCopyWith<MisskeyUserInstance> get copyWith => _$MisskeyUserInstanceCopyWithImpl<MisskeyUserInstance>(this as MisskeyUserInstance, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyUserInstance&&(identical(other.name, name) || other.name == name)&&(identical(other.softwareName, softwareName) || other.softwareName == softwareName)&&(identical(other.softwareVersion, softwareVersion) || other.softwareVersion == softwareVersion)&&(identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl)&&(identical(other.faviconUrl, faviconUrl) || other.faviconUrl == faviconUrl)&&(identical(other.themeColor, themeColor) || other.themeColor == themeColor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,softwareName,softwareVersion,iconUrl,faviconUrl,themeColor);

@override
String toString() {
  return 'MisskeyUserInstance(name: $name, softwareName: $softwareName, softwareVersion: $softwareVersion, iconUrl: $iconUrl, faviconUrl: $faviconUrl, themeColor: $themeColor)';
}


}

/// @nodoc
abstract mixin class $MisskeyUserInstanceCopyWith<$Res>  {
  factory $MisskeyUserInstanceCopyWith(MisskeyUserInstance value, $Res Function(MisskeyUserInstance) _then) = _$MisskeyUserInstanceCopyWithImpl;
@useResult
$Res call({
 String? name, String? softwareName, String? softwareVersion, String? iconUrl, String? faviconUrl, String? themeColor
});




}
/// @nodoc
class _$MisskeyUserInstanceCopyWithImpl<$Res>
    implements $MisskeyUserInstanceCopyWith<$Res> {
  _$MisskeyUserInstanceCopyWithImpl(this._self, this._then);

  final MisskeyUserInstance _self;
  final $Res Function(MisskeyUserInstance) _then;

/// Create a copy of MisskeyUserInstance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? softwareName = freezed,Object? softwareVersion = freezed,Object? iconUrl = freezed,Object? faviconUrl = freezed,Object? themeColor = freezed,}) {
  return _then(MisskeyUserInstance(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,softwareName: freezed == softwareName ? _self.softwareName : softwareName // ignore: cast_nullable_to_non_nullable
as String?,softwareVersion: freezed == softwareVersion ? _self.softwareVersion : softwareVersion // ignore: cast_nullable_to_non_nullable
as String?,iconUrl: freezed == iconUrl ? _self.iconUrl : iconUrl // ignore: cast_nullable_to_non_nullable
as String?,faviconUrl: freezed == faviconUrl ? _self.faviconUrl : faviconUrl // ignore: cast_nullable_to_non_nullable
as String?,themeColor: freezed == themeColor ? _self.themeColor : themeColor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyUserInstance].
extension MisskeyUserInstancePatterns on MisskeyUserInstance {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({required TResult orElse(),}){
final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({required TResult orElse(),}) {final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  return null;

}
}

}


/// @nodoc
mixin _$MisskeyBadgeRole {

 String get name; String? get iconUrl; int? get displayOrder;
/// Create a copy of MisskeyBadgeRole
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyBadgeRoleCopyWith<MisskeyBadgeRole> get copyWith => _$MisskeyBadgeRoleCopyWithImpl<MisskeyBadgeRole>(this as MisskeyBadgeRole, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyBadgeRole&&(identical(other.name, name) || other.name == name)&&(identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,iconUrl,displayOrder);

@override
String toString() {
  return 'MisskeyBadgeRole(name: $name, iconUrl: $iconUrl, displayOrder: $displayOrder)';
}


}

/// @nodoc
abstract mixin class $MisskeyBadgeRoleCopyWith<$Res>  {
  factory $MisskeyBadgeRoleCopyWith(MisskeyBadgeRole value, $Res Function(MisskeyBadgeRole) _then) = _$MisskeyBadgeRoleCopyWithImpl;
@useResult
$Res call({
 String name, String? iconUrl, int? displayOrder
});




}
/// @nodoc
class _$MisskeyBadgeRoleCopyWithImpl<$Res>
    implements $MisskeyBadgeRoleCopyWith<$Res> {
  _$MisskeyBadgeRoleCopyWithImpl(this._self, this._then);

  final MisskeyBadgeRole _self;
  final $Res Function(MisskeyBadgeRole) _then;

/// Create a copy of MisskeyBadgeRole
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? iconUrl = freezed,Object? displayOrder = freezed,}) {
  return _then(MisskeyBadgeRole(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,iconUrl: freezed == iconUrl ? _self.iconUrl : iconUrl // ignore: cast_nullable_to_non_nullable
as String?,displayOrder: freezed == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyBadgeRole].
extension MisskeyBadgeRolePatterns on MisskeyBadgeRole {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({required TResult orElse(),}){
final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({required TResult orElse(),}) {final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  return null;

}
}

}


/// @nodoc
mixin _$MisskeyRoleLite {

 String get id; String get name; String? get color; String? get iconUrl; String? get description; bool? get isModerator; bool? get isAdministrator; int? get displayOrder;
/// Create a copy of MisskeyRoleLite
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyRoleLiteCopyWith<MisskeyRoleLite> get copyWith => _$MisskeyRoleLiteCopyWithImpl<MisskeyRoleLite>(this as MisskeyRoleLite, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyRoleLite&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.color, color) || other.color == color)&&(identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl)&&(identical(other.description, description) || other.description == description)&&(identical(other.isModerator, isModerator) || other.isModerator == isModerator)&&(identical(other.isAdministrator, isAdministrator) || other.isAdministrator == isAdministrator)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,color,iconUrl,description,isModerator,isAdministrator,displayOrder);

@override
String toString() {
  return 'MisskeyRoleLite(id: $id, name: $name, color: $color, iconUrl: $iconUrl, description: $description, isModerator: $isModerator, isAdministrator: $isAdministrator, displayOrder: $displayOrder)';
}


}

/// @nodoc
abstract mixin class $MisskeyRoleLiteCopyWith<$Res>  {
  factory $MisskeyRoleLiteCopyWith(MisskeyRoleLite value, $Res Function(MisskeyRoleLite) _then) = _$MisskeyRoleLiteCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? color, String? iconUrl, String? description, bool? isModerator, bool? isAdministrator, int? displayOrder
});




}
/// @nodoc
class _$MisskeyRoleLiteCopyWithImpl<$Res>
    implements $MisskeyRoleLiteCopyWith<$Res> {
  _$MisskeyRoleLiteCopyWithImpl(this._self, this._then);

  final MisskeyRoleLite _self;
  final $Res Function(MisskeyRoleLite) _then;

/// Create a copy of MisskeyRoleLite
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? color = freezed,Object? iconUrl = freezed,Object? description = freezed,Object? isModerator = freezed,Object? isAdministrator = freezed,Object? displayOrder = freezed,}) {
  return _then(MisskeyRoleLite(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,iconUrl: freezed == iconUrl ? _self.iconUrl : iconUrl // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isModerator: freezed == isModerator ? _self.isModerator : isModerator // ignore: cast_nullable_to_non_nullable
as bool?,isAdministrator: freezed == isAdministrator ? _self.isAdministrator : isAdministrator // ignore: cast_nullable_to_non_nullable
as bool?,displayOrder: freezed == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyRoleLite].
extension MisskeyRoleLitePatterns on MisskeyRoleLite {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({required TResult orElse(),}){
final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({required TResult orElse(),}) {final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  return null;

}
}

}

// dart format on
