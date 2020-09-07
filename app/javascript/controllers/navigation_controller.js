import { Controller } from 'stimulus';

export default class extends Controller {
	static targets = ['userSettings', 'userSettingsOverlay', 'navLink1',
		'navLink2', 'navLink3', 'navLink4', 'navLink5', 'navLink6', 'sidebar'];

	toggleUserSettings() {
		this.userSettingsTarget.classList.toggle('hidden');
		this.userSettingsOverlayTarget.classList.toggle('hidden');
		this.sidebarTarget.classList.toggle('w-0');
		this.sidebarTarget.classList.toggle('w-64');
		this.sidebarTarget.classList.toggle('opacity-0');
		this.sidebarTarget.classList.toggle('opacity-100');
	}
}
