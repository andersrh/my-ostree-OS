Name:           xfce4-whiskermenu-plugin
Version:        2.10.0
Release:        1%{?dist}
Summary:        Alternate application launcher for the Xfce panel

License:        GPLv2+
URL:            https://www.xfce.org/
Source0:        https://archive.xfce.org/src/panel-plugins/xfce4-whiskermenu-plugin/2.10/xfce4-whiskermenu-plugin-%{version}.tar.xz

BuildRequires:  gcc-c++
BuildRequires:  meson
BuildRequires:  gtk3-devel
BuildRequires:  libxfce4ui-devel >= 4.20.0
BuildRequires:  libxfce4util-devel >= 4.20.0
BuildRequires:  xfce4-panel-devel >= 4.20.0
BuildRequires:  gettext

%description
Whisker Menu is an alternate application launcher for Xfce.

%prep
%autosetup

%build
%meson
%meson_build

%install
%meson_install

%find_lang xfce4-whiskermenu-plugin

%files -f xfce4-whiskermenu-plugin.lang
%license COPYING
%doc AUTHORS ChangeLog NEWS
%{_libdir}/xfce4/panel/plugins/libwhiskermenu*
%{_datadir}/xfce4/panel/plugins/whiskermenu.desktop
%{_datadir}/icons/hicolor/*/apps/xfce4-whiskermenu*

%changelog
* Tue Feb 17 2026 Anders <anders@example.com> - 2.10.0-1
- Initial release for Xfce 4.20 compatibility
